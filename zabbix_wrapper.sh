#!/bin/bash

VERSION="2.5"
TASK_NAME="Ans_WrapTest2703"
ZABBIX_HOSTNAME="{HOST.NAME}"
NBX_NAME="{INVENTORY.ALIAS}"
LOG_DIR="/opt/ansible/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$(date +%Y%m%d_%H%M)_${ZABBIX_HOSTNAME}_${TASK_NAME}.log"

# 🔥 worker'ı background başlat
nohup /opt/scripts/worker.sh \
"$ZABBIX_HOSTNAME" \
"$NBX_NAME" \
"$LOG_FILE" \
> /dev/null 2>&1 &

# 🔥 hemen Zabbix'e "başladı" gönder
JSON_OUT="{\"hostname\":\"$ZABBIX_HOSTNAME\",\"task\":\"$TASK_NAME\",\"status\":\"Started\",\"log_file\":\"$(basename "$LOG_FILE")\"}"

zabbix_sender -z 127.0.0.1 -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT"

exit 0