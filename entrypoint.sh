#!/bin/bash
if [[ ! -f /etc/cron.d/rjobs ]]; then touch /etc/cron.d/rjobs && chmod 0644 /etc/cron.d/rjobs; fi > /proc/1/fd/1 2>/proc/1/fd/2
if [[ ! -f /root/.my.cnf ]]; then touch /root/.my.cnf && chmod 0644 /root/.my.cnf; fi > /proc/1/fd/1 2>/proc/1/fd/2
/usr/bin/crontab /etc/cron.d/rjobs > /proc/1/fd/1 2>/proc/1/fd/2
cron &
tail -f /var/log/cron.log