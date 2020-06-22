Apache Airflow
==============

This repo wraps a local, [Dockerized](https://docker.com) deployment of [Apache
Airflow](https://airflow.apache.org), which is used to facilitate the safe,
reliable, and inspectable execution of... whatever you want!

Airflow is a great orchestration tool due to its broad suite of out-of-the-box
features:

- Logging, monitoring, rety-on-failure, and alerting -- all out of the box
- Task parallelization
- REST API
- Robust web UI for administration & monitoring
- Simple design of task workflows ("DAGs")
- [Industry-proven
  success](https://github.com/apache/airflow#who-uses-apache-airflow)

Note that while this deployment scheme is for a dedicated compute host,
Airflow's core platform can be deployed in other schemes with some extra effort.

High-Level Architecture Diagram
-------------------------------

![Airflow](./architecture_full.jpg)

How to use
----------

### TO DO.

Installation & Initialization
-----------------------------

This set of utilities are orchestrated and managed by a few [GNU
Make](https://gnu.org/software/make) targets. The included `Makefile` contains
targets for initializing the host (Debian-based) system,
starting/stopping/monitoring the `docker-compose` stack, and checking the stack
status. All Make targets are to be run from the repo top-level.

The steps for installation & initialization are as follows:

1. If this is a *brand-new host system*, run `make sysinit`. This will configure
   your Debian-based system (idempotently) to have everything it needs to host
   the containerized Airflow deployment. Note that this target depends on a
   `sudo` call to run the included `bash` script, `scripts/sysinit/deb-init.sh`,
   so the running user will need `sudo` privileges and may be prompted for their
   password.

1. Run `make up` to perform all of the stack initialization. This will:

   - Build the relevant Docker images needed using the top-level Dockerfiles and
     various config files found in the `helpers` folder

   - Deploy the stack, wait 10 seconds, and test the HTTP endpoints to ensure
     the services are talking to each other.

 Note that it is ***very important*** to leave stack deployment up to the
 Makefile, and not run it manually, as the Make target builds a custom starting
 Docker image for the Airflow containers, as well as performs the functional
 tests once it's running.

Routing Information
-------------------

Airflow's webserver itself runs on port 8080, and its [REST
API](https://airflow.apache.org/api.html) is available as relative endpoints
starting at `/api/experimental`. Note that while Airflow considers its REST API
"experimental", the authors intend the endpoint *names* (and perhaps the return
values) to potentially change in future versions, not the *overall*
functionality of the REST API. You will still be able to start jobs ("DAG
runs"), get job statuses, etc. if you decide to update Airflow. The version of
Airflow is capped in its Dockerfile as an environment variable,
`AIRFLOW_VERSION`.

Logging
-------

Job logs from the stack are written locally to the container filesystem, at
`/home/airflow/airflow/logs`. The jobs logs can also be sent remotely to Amazon
S3 (or other supported object stores).

Airflow's scheduler and webserver logs are written directly to
`stdout`/`stderr`, and can be configured to send directly to AWS CloudWatch (or
other supported log aggregators).

It would be ideal if Airflow could log all of it output to something like
CloudWatch. However, Airflow is a large, complex system, and logging
*everything* to `stdout`/`stderr` (as the container logs do) would be very
difficult to configure, and indeed read/parse, if it all ended up in a single
log stream. Therefore, this stack can take advantage of Airflow's native S3 etc.
log sync mechanic. When a job run completes, the local log files are synced to
S3 (etc.) automatically by the Airflow process in the container.

Therefore, all logs can be found in AWS (for example) as follows:

- The CloudWatch Log Group name is `/aws/ec2/airflow`, and its two log streams
  are for the Airflow webserver and scheduler logs, named accordingly.

- The S3 Bucket name is `airflow-<ACCT_NO>`, and the log prefix is `logs/`. In
  the subpaths, you will find prefixes for logs for each job (Airflow DAG), each
  *run* of which is its own log file (indicated by an autoincrementing number,
  e.g. `1.log`, `2.log`, etc).

Since CloudWatch and S3 would both used in this scenario, please note that
Airflow would be expecting appropriate attached IAM Roles for authorization to
write to those resources. The included Dockerfile file has a dummy credentials
variable set, and the `scripts/airflow.cfg` file references it. This dummy
config allows for Airflow to use the attached IAM Role on your deployment host.

Developer Notes
---------------

- The web UI is one of the best features of Airflow with respect to
  administration & monitoring, and its docs & examples can be found on Airflow's
  [tour page](https://airflow.apache.org/ui.html). The easiest way to gate
  access to the UI is putting it on the other end of an SSH tunnel. The UI is
  available at `localhost:8080`, if you forward ports over SSH. Broader access
  can be made available if you explore their security & user-management
  documentation.

- You will notice that Airflow has two containers to itself: a webserver, and a
  scheduler. The scheduler service is the actual workhorse of Airflow, while the
  webserver provides the web UI as well as the REST API. Communication between
  the two services is done through the shared metadata database. Typically, the
  scheduler & webserver are run in the same container/host, but splitting them
  up is possible for scalability & separation-of-duties purposes. For this to
  work in separate containers (as is the case here), *both* containers need the
  DAGs folder, an *identical* `airflow.cfg` file, and shared access to a logs
  folder (here, it's a shared Docker volume). You can see this via the base
  image being built with all common configs in it, and then launching containers
  with different startup commands from that. This information is accurate as of
  the time of this writing (2020-04), and may be changed in future Airflow
  versions.
