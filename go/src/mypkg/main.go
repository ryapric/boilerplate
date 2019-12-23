package main

import (
	"fmt"
	h "mypkg/http"
	sl "mypkg/slices"
)

func main() {
	x, err := fmt.Println("waddup")
	if err != nil {
		fmt.Println(x)
	}

	fmt.Println(h.Client("https://icanhazip.com"))

	fmt.Println(sl.GetSlice())
}
