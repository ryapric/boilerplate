# Need to adjust shell used, for `source` command
SHELL = /usr/bin/env bash

# Set venv activation, since make runs each recipe in its own shell instance
# Also set AIRFLOW_HOME
VENV-ACT = source venv/bin/activate

# Note that setting AIRFLOW_HOME to anything within the venv seems to silently kill the webserver on run, so just let it stay default
# This only seems to be true when doing this the way the Makefile is configured


# Default target does initial config
all: install initdb


# Dummy FORCE target dep to make things always run
FORCE:


venv-new: FORCE
	@python3 -m venv --clear venv

install: venv-new
	@$(VENV-ACT) && \
	pip3 install apache-airflow

initdb:
	@$(VENV-ACT) && \
	airflow initdb

webserver:
	@$(VENV-ACT) && \
	airflow webserver -D -p 8080
	@printf "Started Airflow webserver\n"

scheduler:
	@$(VENV-ACT) && \
	airflow scheduler -D
	@printf "Started Airflow scheduler\n"

run:
	@make -s webserver scheduler

stop:
	@pkill -f airflow
	@printf "Terminated all Airflow processes\n"
