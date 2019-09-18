"""
Example Airflow DAG that is triggered via REST API call.
"""


# These are kind of your bread n' butter imports for Bash DAGs
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
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
    'touch_file_with_timestamp',
    description = 'Creates (via touch) a file with the current timestamp',
    default_args = default_args,
    # schedule_interval = timedelta(minutes = 1), # Run on a schedule
    schedule_interval = None # Only run on trigger, manually by UI, CLI, or HTTP
)


# Tasks are instances of Operators
touch_file = BashOperator(
    task_id = 'touch_file',
    bash_command = f'touch {datetime.now()}.txt',
    dag = dag
)

log_task = BashOperator(
    task_id = 'log_task',
    bash_command = 'echo "Created file!" >> log.txt',
    # retries = 3, # Here's where you can override default_args, for example
    dag = dag
)

# Jinja templates! Here's one that will create another file based on the JSON
# you send in to the REST API ('key' can be any key, though; it's parsed as a
# dict when it comes in)
templated_command = """
    echo "{{ dag_run.conf['key'] if dag_run else '' }}" >> json_posts.txt
"""

templated_task = BashOperator(
    task_id = 'templated_command',
    bash_command = templated_command,
    dag = dag
)


# You can chain task dependencies by using Python's bitshift operators (but this isn't the only way!)
touch_file >> log_task >> templated_task
