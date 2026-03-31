#!/bin/bash

VERSION="1.5"
TASK_NAME="Ans_WrapTest2703"
ZABBIX_HOSTNAME="{HOST.NAME}"
NBX_NAME="{INVENTORY.ALIAS}"
LOG_DIR="/opt/ansible/logs"
REBOOT_AFTER_DAYS="{$REBOOT_AFTER_DAYS}"
REBOOT_TIME="{$REBOOT_TIME}"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$(date +%Y%m%d_%H%M)_${ZABBIX_HOSTNAME}_${TASK_NAME}.log"

# worker'ı background başlat
nohup /opt/ansible/worker.sh \
"$ZABBIX_HOSTNAME" \
"$NBX_NAME" \
"$LOG_FILE" \
"$TASK_NAME" \
"$VERSION" \
"$REBOOT_AFTER_DAYS" \
"$REBOOT_TIME" \
> /dev/null 2>&1 &

# hemen Zabbix'e "başladı" gönder
JSON_OUT="{\"hostname\":\"$ZABBIX_HOSTNAME\",\"task\":\"$TASK_NAME\",\"status\":2,\"message\":\"Islem Başlatıldı\",\"log_file\":\"$(basename "$LOG_FILE")\",\"scr_version\":\"$VERSION\"}"
zabbix_sender -z 127.0.0.1 -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT"

exit 0