#!/bin/bash

ZABBIX_HOSTNAME="$1"
NBX_NAME="$2"
LOG_FILE="$3"
TASK_NAME="$4"
VERSION="$5"

# 🔥 Ansible çalıştır
docker run --rm \
--memory="4g" \
-v /opt/ansible:/ansible \
-w /ansible \
-e ANSIBLE_CONFIG=/ansible/ansible.cfg \
--entrypoint "" \
ghcr.io/codeforever42/ansible-runner:1.0 \
ansible-playbook win_test_pbook.yml \
--limit "$NBX_NAME" \
-e "target=$NBX_NAME r_after_days={$REBOOT_AFTER_DAYS} r_time={$REBOOT_TIME}" \
> "$LOG_FILE" 2>&1

EXIT_CODE=$?

# 🔥 LOG PARSE

if grep -qi "Reboot required: True" "$LOG_FILE"; then
    STATUS="Reboot_Pending"
    MSG="Reboot Gerekli, Gorev Planlandi"
    REAL_EXIT=0

elif [ $EXIT_CODE -ne 0 ]; then
    STATUS="Failed"
    MSG="Gercek Bir Hata Alindi!"
    REAL_EXIT=$EXIT_CODE

else
    STATUS="Success"
    MSG="Islem Tamamlandi"
    REAL_EXIT=0
fi

# 🔥 Log temizliği (host bazlı)
LOG_DIR=$(dirname "$LOG_FILE")

ls -t "$LOG_DIR"/*_"$ZABBIX_HOSTNAME"_*.log 2>/dev/null | tail -n +11 | xargs -r rm -f --

# 🔥 JSON gönder
LOG_FILE_NAME=$(basename "$LOG_FILE")

JSON_OUT="{\"hostname\":\"$ZABBIX_HOSTNAME\",\"task\":\"$TASK_NAME\",\"status\":\"$STATUS\",\"message\":\"$MSG\",\"log_file\":\"$LOG_FILE_NAME\",\"scr_version\":\"$VERSION\"}"

zabbix_sender -z 127.0.0.1 -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT"

exit $REAL_EXIT