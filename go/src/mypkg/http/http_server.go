package http

import (
	"fmt"
	"net/http"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func headers(w http.ResponseWriter, req *http.Request) {
	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

// Serve is exported, so should be documented in this string
func Serve(port string) {
	http.HandleFunc("/hello", hello)
	http.HandleFunc("/headers", headers)

	fmt.Printf("Listening on %s\n", port)
	http.ListenAndServe(port, nil)
}
