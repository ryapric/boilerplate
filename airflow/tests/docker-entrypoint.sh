#!/usr/bin/env bash

bash scripts/airflow-start.sh scheduler &
bash scripts/airflow-start.sh webserver &
