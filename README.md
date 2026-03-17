# zbxansible
some ansible tasks for zabbix

### logs klasöründe chmod ve shown unutma!
```
sudo chown -R zabbix:zabbix path/to/ansible/logs
chmod -R 775 path/to/ansible/logs
```

### Docker compose da versiyon uyuşmazlıkları sebebiyle şimdilik kullanım problemli !


### vault encrypt konteyner içinden çalıştır kopyala ve all.yml ye yapıştır  
```
docker exec -it ansible_konteyner_adı bash
```
```
ansible-vault encrypt_string --vault-password-file .vault_pass 'sifrelenecek_parola' --name 'ansible_password'
```
