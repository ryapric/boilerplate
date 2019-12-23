PKGNAME := mypkg
GOPATH := $$(pwd)

SHELL = /usr/bin/env bash

build:
	@printf "Building binaries...\n"
	@GOPATH=$(GOPATH) go build -o $(GOPATH)/bin/$(PKGNAME) $(GOPATH)/src/$(PKGNAME)

test:
	@GOPATH=$(GOPATH) go test

run:
	@GOPATH=$(GOPATH) go run $(GOPATH)/src/$(PKGNAME)/main.go

# Run on a new host to configure VS Code settings. This will only set Go configs
# for VS Code's sake -- your host environment is unchanged.
vscode-settings:
	@mkdir -p ./.vscode
	@cp .vscode-settings.json ./.vscode/settings.json
	@sed -i "s;GOPATH;$$(pwd);" ./.vscode/settings.json
