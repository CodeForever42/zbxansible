#!/bin/bash


# 1. Ayarlar (Zabbix Makrolarından Besleniyor)
VERSION="2.4"
TASK_NAME="Ansible_TEST1603"
ZABBIX_HOSTNAME="{HOST.NAME}"
NBX_NAME="{INVENTORY.ALIAS}"
LOG_DIR="/opt/ansible/logs"
echo $OS_NAME
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d_%H%M)_{HOST.NAME}_${TASK_NAME}.log"

docker run --rm \
  --memory="4g" \
  -v /opt/ansible:/ansible \
  -w /ansible \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  --entrypoint "" \
  ghcr.io/codeforever42/ansible-runner:1.0 \
  ansible-playbook win_test_pbook.yml \
  --limit "$NBX_NAME" \
  -e "target="$NBX_NAME" r_after_days={$REBOOT_AFTER_DAYS} r_time={$REBOOT_TIME}" \
  > "$LOG_FILE" 2>&1

EXIT_CODE=$?

ls -t "$LOG_DIR"/*_"{HOST.NAME}"_*.log 2>/dev/null | tail -n +11 | xargs -r rm -f

if grep -qi "Reboot required: True" "$LOG_FILE"; then
    STATUS="Reboot_Pending"
    MSG="Reboot Gerekli, Gorev Planlandi"
    # Bu beklediğimiz bir durum olduğu için Zabbix'e "Sorun Yok" gibi gitsin (Opsiyonel)
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

LOG_FILE_NAME=$(basename "$LOG_FILE")

JSON_OUT="{\"hostname\":\"{HOST.NAME}\", \"task\":\"$TASK_NAME\", \"status\":\"$STATUS\", \"message\":\"$MSG\", \"log_file\":\"$LOG_FILE_NAME\", \"scr_version\":\"$VERSION\"}"

zabbix_sender -z 127.0.0.1 -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT"
exit $REAL_EXIT