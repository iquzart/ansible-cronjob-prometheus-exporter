Crontab Prometheus Exporter
=========

Ansible role to setup crontab prometheus exporter

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
