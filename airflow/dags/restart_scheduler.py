"""
DAG to periodically restart Airflow's scheduler process, to prevent performance
degradation. Note that because Airflow will be killed before it can register the
task's state, you will not see any "recent" DAG runs (bubbles at center) in the
UI or in the DB. However, the UI will still show that taks instances were run
(on the right), and you can see the last execution date in the dashboard table.
"""

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    # Setting a dynamic start_date is considered bad practice, but this will
    # allow for the scheduler to not kill itself immediately on startup
    'start_date': datetime.today()
}

dag = DAG(
    'restart_scheduler',
    description = "DAG for restarting Airflow's scheduler process (see DAG code for details in docstring)",
    default_args = default_args,
    schedule_interval = '@daily',
    catchup = False
)


# This will kill all Airflow processes. Since this is running in a containerized
# stack with the `restart=always` option, the container will restart
# automatically.
kill_scheduler = BashOperator(
    task_id = 'kill_scheduler',
    bash_command = "pkill -f airflow ",
    dag = dag
)
