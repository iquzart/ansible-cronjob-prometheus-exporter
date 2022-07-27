Crontab Prometheus Exporter
=========

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-iquzart.crontab_prometheus_exporter-blue)](https://galaxy.ansible.com/iquzart/crontab_prometheus_exporter)
![Molecule Test](https://github.com/iquzart/ansible-cronjob-prometheus-exporter/workflows/Molecule%20Test/badge.svg?) 
[![License](https://img.shields.io/:license-mit-blue.svg)](https://badges.mit-license.org)

Ansible role to setup crontab with prometheus metrics

Example Playbook
----------------
```
- hosts: servers
  roles:
      - { role: iquzart.crontab_prometheus_exporter, cron_job: df -h }
```
License
-------

MIT

Author Information
------------------

Muhammed Iqbal <iquzart@hotmail.com>
