"""
DAG whose tasks are executed via AWS ECS. This particular example has extra
configuration to work on the serverless Fargate runtime.
"""

from airflow import DAG
from airflow.contrib.operators.ecs_operator import ECSOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
    'retries': 0,
    'dagrun_timeout': timedelta(hours=2)
}

dag = DAG(
    'ecs',
    description = "DAG for running tasks on AWS ECS",
    default_args = default_args,
    schedule_interval = None,
    catchup = False
)


# Fargate's runtime requires a network configuration. This is *NOT* an
# Airflow-specific requirement -- it's required by AWS' API. As found here:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html
network_configuration = {
    'awsvpcConfiguration': {
        'subnets': ['subnet-id-1', 'subnet-id-2'], # these are the actual, ugly ID values, not friendly names
        'securityGroups': ['sg-id'],
        'assignPublicIp': 'DISABLED'
    }
}

# Can optionally provide override values (including commands) to the container
# used in the Task Definition. As found here:
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ecs.html#ECS.Client.run_task
overrides = {
    'containerOverrides': [
        {
            'name': 'nginx', # this is the container name that's launched
            'command': ['custom', 'command']
        }
    ]
}

ecs_task = ECSOperator(
    task_id = 'ecs_task', # this is Airflow's task name, don't get confused!
    task_definition = 'task_def_name', # actual task def name in your cluster
    cluster = 'cluster_name',
    region_name = 'us-east-1', # required, for some reason
    launch_type = 'FARGATE',
    network_configuration = network_configuration,
    overrides = {}, # or `overrides` mapping from above
    aws_conn_id = None, # let boto3 pull attached Role
    dag = dag
)
