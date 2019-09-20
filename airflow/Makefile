# Need to adjust shell used, for `source` command
SHELL = /usr/bin/env bash

# Set venv activation, since make runs each recipe in its own shell instance
# Also set AIRFLOW_HOME
VENV-ACT = source venv/bin/activate

# Note that setting AIRFLOW_HOME to anything within the venv seems to silently kill the webserver on run, so just set it as the default
# This only seems to be true when doing this the way the Makefile is configured
AIRFLOW_HOME = ~/airflow


# Default target just restarts daemon processes
all: stop start

# FRESH will do a full wipe, and a fresh install, including starting services
FRESH: wipe install init start


# Dummy FORCE target dep to make things always run
FORCE:


# Create new Python virtual environment ('venv')
venv-new: FORCE
	@python3 -m venv --clear venv


# This will install Airflow to a local venv, as well as any extras you specify.
# crypto is default here as an extra; on init, airflow.cfg will have its Fernet
# key filled in, and Connection details as well as Variables will be encrypted
# in the DB once added.
install: venv-new
	@printf "Installing Airflow to ./venv...\n"
	@$(VENV-ACT) && \
	pip3 install wheel && \
	pip3 install 'apache-airflow[crypto]'


# This will initilaize the database (and also dump to $AIRFLOW_HOME), so to get
# rid of the examples in there, you'd need to run the init, change the config,
# then reset the database.
init:
	@printf "Initializing Airflow metadata database...\n"
	@$(VENV-ACT) && \
	mkdir -p $(AIRFLOW_HOME)/dags && \
	airflow initdb && \
	sed -i 's/load_examples = True/load_examples = False/g' $(AIRFLOW_HOME)/airflow.cfg && \
	sed -i 's/dags_are_paused_at_creation = True/dags_are_paused_at_creation = False/g' $(AIRFLOW_HOME)/airflow.cfg && \
	airflow resetdb -y
	@make -s add-dags
	@chmod +x $(AIRFLOW_HOME)/dags/example_shell_script.sh

add-dags:
	@ln -fs $${PWD}/dags/* $(AIRFLOW_HOME)/dags/
	@ln -fs $${PWD}/dags/.airflowignore $(AIRFLOW_HOME)/dags/

webserver:
	@$(VENV-ACT) && \
	airflow webserver -D -p 8080
	@printf "Started Airflow webserver\n"

scheduler:
	@$(VENV-ACT) && \
	airflow scheduler -D
	@printf "Started Airflow scheduler\n"

start: webserver scheduler


stop:
	@pkill -f airflow
#	@pkill -f airflow || printf "No Airflow processes to stop\n"
	@printf "Terminated all Airflow processes\n"


# Trigger a manual run of the example DAG via Airflow's REST API
trigger-reference-dag-rest:
	@curl \
		-X POST \
		-H 'Content-type: application/json' \
		-d '{"conf": {"key": "value"}}' \
		'localhost:8080/api/experimental/dags/reference_dag/dag_runs'


# Get status of the above dag_run (by latest run ID)
get-status-reference-dag-rest:
	@curl -sS 'localhost:8080/api/experimental/dags/reference_dag/dag_runs' | jq 'max_by(.id).state'


# Take this one out if going into an actual, non-toy environment
wipe:
	@rm -rf $(AIRFLOW_HOME)
	@rm -rf venv/
	@printf 'Wiped $$AIRFLOW_HOME ($(AIRFLOW_HOME)) & ./venv from system\n'
