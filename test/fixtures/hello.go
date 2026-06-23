package main

import (
	"fmt"
	"os"
)

func greet(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}

func main() {
	name := os.Getenv("USER")
	if name == "" {
		name = "SRE"
	}
	fmt.Println(greet(name))
}
