FROM debian:buster

RUN apt-get update && apt-get install -y ansible

COPY main.yaml main.yaml

RUN ansible-playbook -v main.yaml

CMD ["bash"]
