package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"
	"sync"
	//"time"
)

func lookup(line string, wg *sync.WaitGroup) {

	var testmx bool
	var servers string

	mxrecords, err := net.LookupMX(line)
	if err == nil {
		for _, mx := range mxrecords {
			addresses, _ := net.LookupIP(mx.Host)
			for i := 0; i < len(addresses); i++ {

				if strings.Contains(addresses[i].String(), ":") {
					testmx = true

				}
				servers = servers + "," + mx.Host
			}
		}
	}

	fmt.Println(line, testmx, servers)

	testmx = false

	defer wg.Done()

}

func main() {
	var wg sync.WaitGroup
	var concurrent int

	if len(os.Args) < 2 {
		fmt.Println("Dummer")
		os.Exit(20)
	}
	file := os.Args[1]

	concurrent = 0
	f, _ := os.Open(file)
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		concurrent++
		wg.Add(1)
		go lookup(line, &wg)
		//fmt.Println(concurrent)
		if concurrent == 800 {
			//time.Sleep(5 * time.Second)
			concurrent = 0
			//fmt.Println("Waiting")
			wg.Wait()
		}
	}
}
