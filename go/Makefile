GOPATH := $$(go env GOPATH)

SHELL = /usr/bin/env bash

build:
	@printf "Building binaries...\n"
	@go build -o $(GOPATH)/bin/mypkg $(GOPATH)/src/mypkg

test:
	@go test

run:
	@go run $(GOPATH)/src/mypkg/main.go

# Run on a new host to configure VS Code settings
vscode-settings:
	@mkdir -p ./.vscode
	@cp .vscode-settings.json ./.vscode/settings.json
	@sed -i "s;GOPATH;$$(pwd);" ./.vscode/settings.json
