#!/usr/bin/env bash
set -e

# Assumes a Debian-based host

vars="./scripts/vars.sh"
workdir="/airflow-scratch"

source "${vars}"

apt-get update

mkdir -p "${workdir}"
cd "${workdir}" || exit 1

# Send in command as single-quoted string
run-as-airflow() {
  sudo -u airflow bash -c "pwd && source ${vars} && $1"
}

install-sysutils() {
  apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    nano \
    git \
    less \
    nano \
    htop \
    nmap \
    jq
}

create-airflow-user() {
  groupadd -r airflow
  useradd -r -m -g airflow airflow
  chown -R -c airflow:airflow "${workdir}"/*
}

# Make directories for Airflow and its services
create-dirs() {
  true
}

install-airflow() {
  run-as-airflow 'pip3 install -U "apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION}.*" --no-warn-script-location'
}

create-airflow-services() {
  true
}

main() {
  install-sysutils
  create-airflow-user

  install-airflow

  # Testing is done in Docker, which does not support systemd/other init systems
  if [[ "$1" != 'test' ]]; then
    create-airflow-services
  fi
}

main "$1"
