# Name of package
PKGNAME := $$(grep 'name = ' setup.py | sed -r 's/name = '"'"'(.*)'"'"',/\1/')

# Need to adjust shell used, for `source` command
SHELL = /usr/bin/env bash

# Set venv activation, since make runs each recipe in its own shell instance
VENV-ACT = source venv/bin/activate

# More modular definitions for testing, to make it easier to write for Travis
# w/o a lot of copy-paste
# Note that I'm having a hard time getting `define` blocks to work, here, as
# well as .ONESHELL:
DEV-PKGS = pip3 install wheel && pip3 install setuptools coverage pytest pytest-cov pytest-flask
TEST = python3 -m pytest --cov $(PKGNAME) . -v
COVCHECK = if [ $$(python3 -m coverage report | tail -1 | awk '{ print $$NF }' | tr -d '%') -lt $(COVREQ) ]; then echo -e "\nFAILED: Insufficient test coverage (<$(COVREQ)%)\n" 2>&1 && exit 1; fi

# Required test coverage; default to 95%
ifeq ($(COVREQ),)
COVREQ := 95
endif


all: test

# Dummy FORCE target dep to make things always run
FORCE:

venv: FORCE
	@python3 -m venv --clear venv

dev-pkgs: venv
	@$(VENV-ACT) && \
	$(DEV-PKGS)

test: clean venv dev-pkgs install_venv
	@$(VENV-ACT) && \
	$(TEST) # don't chain from here, so failed tests throw shell error code
	@$(COVCHECK)
	@make -s clean
	@rm -rf venv

test-travis:
	$(DEV-PKGS)
	$(TEST)
	$(COVCHECK)

build: venv dev-pkgs
	@$(VENV-ACT); \
	python3 setup.py sdist bdist_wheel

install_venv: venv
	@$(VENV-ACT); \
	if [ -e ./requirements.txt ]; then pip3 install -r requirements.txt; else pip3 install . ; fi

clean: FORCE
	@find . -type d -regextype posix-extended -regex ".*\.egg-info|.*py(test_)?cache.*" -exec rm -rf {} +
	@find . -type d -regextype posix-extended -regex ".*venv.*" -exec rm -rf {} +
	@find . -type f -regextype posix-extended -regex ".*\.pyc" -exec rm {} +
	@find . -type f -regextype posix-extended -regex ".*,?cover(age)?" -exec rm {} +
	@find . -name "test.db" -exec rm {} +

# Install to system library
install: FORCE
#ifeq ($(`whoami`), $(filter $(`whoami`), 'root' 'travis'))
ifeq ($(`whoami`), 'root')
	pip3 install --no-warn-script-location .
else
	pip3 install --user --no-warn-script-location .
endif

doc: FORCE
	@make -C docs html

uninstall: FORCE
	pip3 uninstall -y $(PKGNAME)

