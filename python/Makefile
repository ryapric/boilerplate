# Name of package. If not a package, set this statically
PKGNAME := $(shell dirname `find . -maxdepth 2 -name '__init__.py' | grep -v 'test' | sed 's;\.\/;;g'`)

SHELL = /usr/bin/env bash


all: test

# Dummy FORCE target dep to make certain targets always run
FORCE:

# All test logic can be found in the script being run by this target
test: clean
	@bash ./tests/run-tests.sh

test-docker:
	@if [ -z $(pyver) ]; then \
		printf "Must supply 'pyver' variable\n"; \
		exit 1; \
	fi
	@sed 's/pyver/$(pyver)/g' Dockerfile-test > Dockerfile-versioned
	@docker build -f Dockerfile-versioned -t $(PKGNAME):python-$(pyver) .
	@docker run --rm -it ghostwriter:python-$(pyver)

clean: FORCE
	@find . -type d -regextype posix-extended -regex ".*\.egg-info" -exec rm -rf {} +
	@find . -type d -regextype posix-extended -regex ".*py(test_)?cache.*" -exec rm -rf {} +
	@find . -type d -regextype posix-extended -regex ".*mypy_cache.*" -exec rm -rf {} +
	@find . -type d -regextype posix-extended -regex ".*venv.*" -exec rm -rf {} +
	@find . -type f -regextype posix-extended -regex ".*\.pyc" -exec rm {} +
	@find . -type f -regextype posix-extended -regex ".*,?cover(age)?" -exec rm {} +
	@find . -name "test.db" -exec rm {} +

# Install to system library
install: FORCE
ifeq ($(`whoami`), 'root')
	pip3 install --no-warn-script-location .
else
	pip3 install --user --no-warn-script-location .
endif

uninstall: FORCE
	pip3 uninstall -y $(PKGNAME)
