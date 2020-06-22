# !!! DO NOT USE THIS FOR CONTAINERIZED DEPLOYMENT, ONLY FOR TESTING !!! #

FROM python:3.7-buster

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /airflow-scratch

COPY . .

RUN bash scripts/sysinit-deb.sh test

USER airflow

EXPOSE 8080

# Default dummy command as placeholder; Scheduler & Webserver containers will
# provide their own launch commands in docker-compose.yaml
CMD ["bash", "tests/docker-entrypoint.sh"]
