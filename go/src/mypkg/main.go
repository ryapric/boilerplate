package main

import (
	"fmt"
	h "mypkg/http"
)

func main() {
	x, err := fmt.Println("waddup")
	if err != nil {
		fmt.Println(x)
	}
	h.Client("https://icanhazip.com")
	h.Serve(":8080")
}
