# zbxansible
some ansible tasks for zabbix

#### Docker compose da versiyon uyuşmazlıkları sebebiyle şimdilik kullanım problemli !


#### 1.Git clone
```

```


#### logs klasöründe chmod ve chown unutma!
```
sudo chown -R zabbix:zabbix path/to/ansible/logs
chmod -R 775 path/to/ansible/logs
```

example dosyalarını kopyalarak içindeki ayarları yapınız.




#### vault encrypt konteyner içinden çalıştır kopyala ve all.yml ye yapıştır  
```
docker exec -it ansible_konteyner_adı bash
```
```
ansible-vault encrypt_string --vault-password-file .vault_pass 'sifrelenecek_parola' --name 'ansible_password'
```


#### Update from Git 
```

```
