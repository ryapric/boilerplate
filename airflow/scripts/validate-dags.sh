#!/usr/bin/env bash
set -e



# Parse the DAG files, to try & catch syntax errors before they get deployed
for dag in ${AIRFLOW_HOME}/dags/*.py; do
  python3 "${dag}"
done
