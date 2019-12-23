package http

import (
	"bufio"
	"fmt"
	"net/http"
)

// GetIP is exported, so should be documented in this string
func GetIP() string {
	resp, err := http.Get("https://icanhazip.com")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("\nResponse status:", resp.Status)

	scanner := bufio.NewScanner(resp.Body)
	out := ""
	for scanner.Scan() {
		out += scanner.Text()
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	return out
}
