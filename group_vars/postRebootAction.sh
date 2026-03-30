#!/bin/bash

ZABBIX_HOSTNAME="{HOST.NAME}"
TASK_NAME="Post-Reboot Status Update"
STATUS="Restarted"
VERSION="1.0-PRA"

JSON_OUT="{\"hostname\":\"$ZABBIX_HOSTNAME\", \"task\":\"$TASK_NAME\", \"status\":\"$STATUS\", \"message\":\"Restarted\", \"log_file\":\"log tutulmadı\", \"scr_version\":\"$VERSION\"}"

zabbix_sender -z 127.0.0.1 -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT" > /dev/null 2>&1

exit 0