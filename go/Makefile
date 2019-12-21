GOPATH := `pwd`

build:
	@printf "Building binaries, from src/* to bin/* ...\n"
	@GOPATH=$(GOPATH) go build -o bin/mypkg ./src/*

run:
	@GOPATH=$(GOPATH) go run src/mypkg/main.go
