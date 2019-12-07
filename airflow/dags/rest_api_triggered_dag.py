"""
DAG that is expected to be triggered by POSTs to Airflow's REST API
"""


from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
    'email': ['ryapric@gmail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes = 5),
    'dagrun_timeout': timedelta(hours = 2)
}

dag = DAG(
    'rest_api_triggered',
    description = "DAG that is expected to be triggered by POSTs to Airflow's REST API",
    default_args = default_args,
    schedule_interval = None, # Manual trigger, so no schedule
    catchup = False
)


# # If this were a dynamic shell command to be run, this is how you might set it
# # up with Jinja templating. Airflow needs a dictionary-like object (e.g. JSON)
# # with a top-level "conf" key to be passed as config data to the `dag_run`
# # meta-object. A JSON example might look like: {"conf": {"var1": "value1",
# # "var2": "value2", "etc": "etc"}}. Airflow does not provide any shell-injection
# # protection, so include some of your own here.
# bash_command = """\
# {%- set var1 = dag_run.conf['var1'] %}
# {%- set var2 = dag_run.conf['var2'] %}
# {%- set cmd = '/path/to/your/command {} {}'.format(var1, var2) %}
# {# Set vars to informative string if any injection attempts found #}
# {%- set cmd = 'INJECTION_ATTEMPT && exit 1' if '(' in cmd or '`' in cmd else cmd %}
# {%- if cmd = 'INJECTION_ATTEMPT' %}
# printf "!!! Shell injection attempt detected !!! Exiting\n" && exit 1
# {%- endif %}

# # Set shell options
# set -e -u -o pipefail

# # Run command. stdout/stderr from `cmd` are captured in Airflow's logs, but you
# # can tee out to another log file, if you wish
# {{ cmd }} 2>&1 | tee -a /path/to/some/logfile"""

# run_bash_command = BashOperator(
#     task_id = 'run_bash_command',
#     bash_command = bash_command,
#     execution_timeout = timedelta(hours = 2),
#     dag = dag
# )


# If this were instead a Python function handling the request, the `conf` object
# can be accessed via the `kwargs` passed in. Note that the function signature
# needs both `ds` (an Airflow macro object) AND `**kwargs` arguments for that to
# work. Also note that you don't *need* `conf`: you can just as easily call a
# function that takes no arguments, depending on your use case.
def print_conf(ds, **kwargs):
    var_i_want = kwargs['dag_run'].conf.get('var1')
    print(var_i_want)
    return "Whatever you return here is printed to the logs"
# end def

run_python = PythonOperator(
    task_id = 'run_python',
    provide_context = True, # pass this if you want access to the `conf` object
    python_callable = print_conf,
    dag = dag
)
