# Name of package
PKGNAME = pkgname

# Need to adjust shell used, for `source` command
SHELL = /usr/bin/env bash

# Set venv activation, since make runs each recipe in its own shell instance
venv-act = source venv/bin/activate


all: venv dev-pkgs install_venv test clean

# Dummy FORCE target dep to make things always run
FORCE:

venv: FORCE
	@rm -rf venv
	@python3 -m venv venv

dev-pkgs: venv
	@$(venv-act); \
	pip3 install setuptools pytest wheel

test: venv dev-pkgs install_venv clean
	@$(venv-act); \
	python3 -m pytest -v

build: venv dev-pkgs
	@$(venv-act); \
	python3 setup.py sdist bdist_wheel

install_venv: venv
	@$(venv-act); \
	pip3 install .

clean:
	@find . -type d -regextype posix-extended -regex ".*\.egg-info|.*cache.*" -exec rm -rf {} +
	@find . -type f -regextype posix-extended -regex ".*\.pyc" -exec rm {} +
	@find . -name "test.db" -exec rm {} +

# Install to system library
install:
ifeq ($(`whoami`), 'root')
	pip3 install .
else
	pip3 install --user .
endif

doc:
	@pandoc -o README.html README.md
	@echo "Created README.html"

uninstall:
	pip3 uninstall -y $(PKGNAME)
