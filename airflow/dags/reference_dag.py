"""
Example Airflow DAG that is triggered via REST API call.
"""


# These are kind of your bread n' butter imports for Bash DAGs
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.models.variable import Variable
from datetime import datetime, timedelta


# Default args to pass as dict to DAG() constructor. These can be overwritten by
# passing the same arg again in the task calls
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
    'email': ['ryapric@gmail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 5,
    'retry_delay': timedelta(seconds = 5)
}

dag = DAG(
    'reference_dag',
    description = "A DAG demonstrating some of Airflow's capabilities",
    default_args = default_args,
    # schedule_interval = timedelta(minutes = 1), # Run on a schedule; can also be a cron expression
    schedule_interval = None # Only run on trigger, manually by UI, CLI, or HTTP
)


# Tasks are instances of Operators
# When using BashOperator, I'm not sure where Airflow redirects its output,
# so just use absolute paths
make_file = BashOperator(
    task_id = 'make_file',
    bash_command = "echo 'File created at: {}' >> /home/ryan/created_file.txt".format(datetime.now()),
    dag = dag
)


# Jinja templates! Here's one that will create another file based on the JSON
# you send in to the CLI or REST API ('key' can be any key, though; it's
# parsed as a dict when it comes in). The JSON needs to be an object with a
# 'conf' key, which THEN has a nested object of the dict keys to work with
# (e.g. {"conf": {"key":, "value"}} )
templated_command = """
    echo "{{ dag_run.conf['key'] if dag_run else '' }}" >> /home/ryan/conf_object_posts.txt
"""

templated_task = BashOperator(
    task_id = 'templated_command',
    bash_command = templated_command,
    dag = dag
)


# Airflow has a Variable class, which allows storing & retrieving variables
# (encrypted by default in the DB, if crypto is installed). Here, I'm setting
# a dummy Variable, but you can also set them through the UI, CLI, or REST API.
# Note that you access a Variable in a Jinja template via
# 'var.<output>.<varname>', where '<output>' can be 'value', or 'json'.
Variable.set(key = 'saved_variable', value = 'Hey look, a Variable!')

use_variables = BashOperator(
    task_id = 'use_variables',
    bash_command = "echo '{{ var.value.saved_variable }}' >> /home/ryan/variables.txt",
    dag = dag
)


# If you want to run a shell *script* (by itself), leave a trailing space at
# the end of the bash_command. Otherwise, it tries to render a Jinja template,
# which will fail.
run_script = BashOperator(
    task_id = 'run_script',
    bash_command = '/home/ryan/airflow/dags/example_shell_script.sh ',
    dag = dag
)


# You can chain task dependencies by using Python's bitshift operators
# (this isn't the only way, but it's the recommended one). This should come
# last in the DAG file.
make_file >> use_variables >> run_script >> templated_task
