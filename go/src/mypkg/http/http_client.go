package http

import (
	"bufio"
	"fmt"
	"net/http"
)

// Client is exported, so should be documented in this string
func Client(url string) {
	resp, err := http.Get(url)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("\nResponse status:", resp.Status)

	scanner := bufio.NewScanner(resp.Body)
	for i := 0; scanner.Scan() && i < 1; i++ {
		fmt.Printf("My IP: %s\n\n", scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}
}
