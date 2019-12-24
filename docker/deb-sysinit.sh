#!/usr/bin/env bash
set -e

# This script will intialize system requirements for a Debian-based Docker host.
# Specifically, the system will receive:
#   - Docker
#   - Docker Compose (and python3 utilities to install it, if not present)
#
# Sometimes the host will throw segfaults on Docker Compose install, so it will
# be installed to a virtual environment named `venv` in the parent directory you
# specify as the first CLI arg.

# Pin docker-compose version with a leading major-minor, to prevent any breakage
export DOCKER_COMPOSE_VER=1.24

# docker-compose venv path. Defaults to `.`
if [[ -z "$1" ]]; then
  export VENV_HOME='.'
else
  export VENV_HOME="$1"
fi

# Install Docker, if it's not already installed
if ! command -v docker >/dev/null; then
  curl https://get.docker.com | bash
  sudo usermod -aG docker "${USER}"
fi

# Install docker-compose, and pip3 if needed
if ! command -v pip3; then
  sudo apt-get update && sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-venv
fi
if ! command -v docker-compose; then
  sudo apt-get install -y \
    libffi-dev \
    libssl-dev
  python3 -m venv "${VENV_HOME}/venv"
  source "${VENV_HOME}/venv/bin/activate"
  pip3 install "docker-compose==${DOCKER_COMPOSE_VER}.*"
  deactivate
fi

# Woo!
printf "\nHost configuraton complete! Please *log out and back in* to use Docker without 'sudo'\n"
