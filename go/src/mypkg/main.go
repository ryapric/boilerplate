package main

import (
	"fmt"
	h "mypkg/http"
	sl "mypkg/slices"
)

func main() {
	fmt.Println(h.GetIP())
	fmt.Println(sl.GetSlice())
}
