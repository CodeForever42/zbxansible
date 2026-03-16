#!/bin/bash

# 1. Ayarlar (Zabbix Makrolarından Besleniyor)
TASK_NAME="Windows_Reboot"
ZABBIX_SERVER='{$ANSIBLE.SENDER.IP}'
LOG_DIR="/home/zroot/ansible/logs"

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d_%H%M)_{HOST.NAME}_${TASK_NAME}.log"

# 2. Ansible Çalıştır
docker run --rm \
  -v /home/zroot/ansible:/ansible \
  -w /ansible \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  --entrypoint "" \
  ghcr.io/codeforever42/ansible-runner:latest \
  ansible-playbook win_test_pbook.yml \
  --limit "{HOST.NAME}" \
  -e "target={HOST.NAME} r_after_days={$REBOOT_AFTER_DAYS} r_time={$REBOOT_TIME}" \
  > "$LOG_FILE" 2>&1

EXIT_CODE=$?

# 3. Sonuç Değerlendirme ve Log Yolunu Budama
STATUS=$([ $EXIT_CODE -eq 0 ] && echo "Success" || echo "Failed")
MSG=$([ $EXIT_CODE -eq 0 ] && echo "Islem Basarili" || echo "Hata Alindi!")
LOG_FILE_NAME=$(basename "$LOG_FILE")

# 4. Ansible Trapper'a Gönder (JSON içinde sadece dosya adı var)
JSON_OUT="{\"task\":\"$TASK_NAME\", \"status\":\"$STATUS\", \"message\":\"$MSG\", \"log_file\":\"$LOG_FILE_NAME\"}"

zabbix_sender -z $ZABBIX_SERVER -s "{HOST.NAME}" -k ansible.result -o "$JSON_OUT"

exit $EXIT_CODE