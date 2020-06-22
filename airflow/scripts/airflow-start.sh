#!/usr/bin/env bash

# Single-quoted because aliases are expanded on use, not definition
alias airflow='${HOME}/.local/bin/airflow'

case $1 in
  scheduler)
    # First init & upgrade database (both idempotent if already up/current)
    airflow initdb
    airflow upgradedb
    # Start scheduler
    airflow scheduler
  ;;

  webserver)
    airflow webserver
  ;;
esac
