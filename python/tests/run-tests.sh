#!/usr/bin/env bash

### Vars

# pkgname can be reliably found this way
pkgname=$(dirname "$(find . -maxdepth 2 -name '__init__.py' | grep -v 'test' | sed 's;\.\/;;g')")

# Test coverage requirement percentage, as integer. Test suite will fail if less
# than this value
covreq=0

# Setup venv
python3 -m venv --clear venv
. ./venv/bin/activate


install-dev() {
  pip3 install -U wheel setuptools '.[dev]' >/dev/null
}

test-package() {
  python3 -m pytest --cov "${pkgname}" . -v
}

type-check() {
  python3 -m mypy -p "${pkgname}"
}

coverage-check() {
  if [[ $(python3 -m coverage report | tail -1 | awk '{ print $NF }' | tr -d '%') -lt "${covreq}" ]]; then
    printf "\nFAILED: Insufficient test coverage (<%s%%)\n" "${covreq}" 2>&1 && exit 1
  fi
}

_info() {
  printf "\n===> %s...\n\n" "${@}"
}

main() {
  _info 'Setting up'
  install-dev

	_info 'Running tests'
	test-package
	
  _info 'Running coverage check'
  coverage-check
	
  _info 'Running typecheck'
	type-check
  
  _info 'Cleaning up'
	make -s clean
}


main
