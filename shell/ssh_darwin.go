package shell

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strconv"
	"syscall"
	"unsafe"

	"github.com/creack/pty"
	"github.com/gliderlabs/ssh"
)

var (
	defaultShell = shell
	shell        = "sh"
	bash         = "bash"
)

// SSHServer starts a gliderlabs ssh server on a port and attachs to the PTY
// IO is copied in and out via the ssh server from `stdin` and `stdout`
func SSHServer(BasePort int) {
	Port := strconv.Itoa(BasePort + 0)
	log.Println("Starting SSH server on port " + Port + "...")

	forwardHandler := &ssh.ForwardedTCPHandler{}

	server := ssh.Server{
		LocalPortForwardingCallback: ssh.LocalPortForwardingCallback(func(ctx ssh.Context, dhost string, dport uint32) bool {
			log.Println("Accepted forward", dhost, dport)
			return true
		}),
		Addr: "127.0.0.1:" + Port,
		Handler: ssh.Handler(func(s ssh.Session) {
			cmd := exec.Command(defaultShell)
			ptyReq, winCh, isPty := s.Pty()

			if isPty {
				cmd.Env = append(cmd.Env, fmt.Sprintf("TERM=%s", ptyReq.Term))
				f, err := pty.Start(cmd)
				if err != nil {
					panic(err)
				}

				go func() {
					for win := range winCh {
						setWinsize(f, win.Width, win.Height)
					}
				}()

				go func() {
					io.Copy(f, s) // stdin
				}()

				io.Copy(s, f) // stdout
				cmd.Wait()

			} else {
				io.WriteString(s, "No PTY requested.\n")
				s.Exit(1)
			}
		}),
		ReversePortForwardingCallback: ssh.ReversePortForwardingCallback(func(ctx ssh.Context, host string, port uint32) bool {
			log.Println("Attempt to bind", host, port, "granted")
			return true
		}),
		RequestHandlers: map[string]ssh.RequestHandler{
			"tcpip-forward":        forwardHandler.HandleSSHRequest,
			"cancel-tcpip-forward": forwardHandler.HandleSSHRequest,
		},
	}

	log.Fatal(server.ListenAndServe())
}

func setWinsize(f *os.File, w, h int) {
	syscall.Syscall(syscall.SYS_IOCTL, f.Fd(), uintptr(syscall.TIOCSWINSZ),
		uintptr(unsafe.Pointer(&struct{ h, w, x, y uint16 }{uint16(h), uint16(w), 0, 0})))
}
