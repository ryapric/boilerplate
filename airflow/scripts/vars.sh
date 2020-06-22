#!/usr/bin/env bash

# Export variables for Airflow init

export AIRFLOW_VERSION=1.10

# Airflow's homedir (not the user, the tool)
export AIRFLOW_HOME=/home/airflow/airflow

# Comma-separated (no spaces) list of Airflow Extras; passed to pip
export AIRFLOW_EXTRAS=aws,s3

# Can set an empty variable to allow Airflow to hook into Cloud provider via the
# IAM instance profile/service account/etc.
export AIRFLOW_CONN_CLOUD_PROVIDER_PROFILE=

# In case Debian gets salty
export DEBIAN_FRONTEND=noninteractive
