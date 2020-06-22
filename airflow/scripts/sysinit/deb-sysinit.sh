#!/usr/bin/env bash

# This script will intialize system requirements for a Debian-based Docker host.
# Specifically, the system needs:
#   - Docker
#   - Docker Compose (and pip3 to install it, if not present)

# Pin docker-compose version with a leading major-minor, to prevent any breakage
export DOCKER_COMPOSE_VER=1.24

# Install Docker, if it's not already installed (using a static, vetted, local
# version of their headless installer)
if ! command -v docker >/dev/null; then
  bash ./scripts/sysinit/docker-install.sh
  sudo usermod -aG docker "${USER}"
fi

# Install docker-compose, and pip3 if needed
if ! command -v pip3; then
  sudo apt-get update && sudo apt-get install -y python3 python3-pip
fi
if ! command -v docker-compose; then
  sudo apt-get install -y \
    libffi-dev \
    libssl-dev
  pip3 install "docker-compose==${DOCKER_COMPOSE_VER}.*"
fi

# Woo!
printf "\nHost configuraton complete! Please *log out and back in* to use Docker without 'sudo'\n"
