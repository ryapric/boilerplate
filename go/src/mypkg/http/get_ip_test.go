package http

import (
	"strings"
	"strconv"
	"testing"
)

func TestGetIP(t *testing.T) {
	ip := GetIP()
	
	if strings.Count(ip, ".") != 3 {
		t.Errorf("Doesn't look like an IPv4 address! (got: %s)", ip)
	}

	ipBytes := strings.Split(ip, ".")
	ipBytesError := false
	for _, ipByte := range ipBytes {
		digit, err := strconv.Atoi(ipByte)
		if err != nil {
			panic(err)
		}
		if digit < 0 || digit > 255 {
			ipBytesError = true
		}
	}
	if ipBytesError {
		t.Errorf("Bad IPv4 byte structure")
	}
}
