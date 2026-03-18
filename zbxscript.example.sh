#!/bin/bash

# 1. Ayarlar (Zabbix Makrolarından Besleniyor)
TASK_NAME="Ansible_TEST1603"
ZABBIX_SERVER='{$ANSIBLE.SENDER.IP}'
ZABBIX_HOSTNAME="{HOST.NAME}"
OS_NAME="{INVENTORY.NAME}"
LOG_DIR="/home/zroot/ansible/logs"
echo $OS_NAME
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
  --limit "$OS_NAME" \
  -e "target="$OS_NAME" r_after_days={$REBOOT_AFTER_DAYS} r_time={$REBOOT_TIME}" \
  > "$LOG_FILE" 2>&1

EXIT_CODE=$?
# 1. Log dosyasında "reboot is required" ibaresini ARA (Büyük/Küçük harf duyarsız -i)
if grep -qi "reboot is required" "$LOG_FILE"; then
    STATUS="Reboot_Pending"
    MSG="Reboot Gerekli, Gorev Planlandi"
    # Bu beklediğimiz bir durum olduğu için Zabbix'e "Sorun Yok" gibi gitsin (Opsiyonel)
    REAL_EXIT=0

# 2. Eğer reboot mesajı yoksa ve EXIT_CODE sıfır değilse (Gerçek Hata)
elif [ $EXIT_CODE -ne 0 ]; then
    STATUS="Failed"
    MSG="Gercek Bir Hata Alindi!"
    REAL_EXIT=$EXIT_CODE

# 3. Her şey tertemizse
else
    STATUS="Success"
    MSG="Islem Tamamlandi"
    REAL_EXIT=0
fi

# JSON Hazırlama ve Gönderme
LOG_FILE_NAME=$(basename "$LOG_FILE")


JSON_OUT="{\"hostname\":\"{HOST.NAME}\", \"task\":\"$TASK_NAME\", \"status\":\"$STATUS\", \"message\":\"$MSG\", \"log_file\":\"$LOG_FILE_NAME\"}"



zabbix_sender -z $ZABBIX_SERVER -s "$ZABBIX_HOSTNAME" -k ansible.result -o "$JSON_OUT"
exit $REAL_EXIT