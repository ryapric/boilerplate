[Ansible](https://docs.ansible.com/ansible/latest/index.html)
=============================================================

***Note: at the time of this writing, the latest Ansible version was 2.9.5***

Ansible is a configuration management tool. This subrepo includes a file
structure for using Ansible from a control node.

- `main.yaml`: Primary Ansible Playbook

- `hosts`: Host inventory file. Pass via `ansible<-playbook> -i hosts` to use.

- `ansible.cfg`: Ansible configuration file. Read contents for more details.
