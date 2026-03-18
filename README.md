## zbxansible
Zabbix üzerinden Action script ile Zabbix-Proxy de Ansible taskları çalıştıracağız.

Zabbix hostlarında Inventory kısmı Automatic te olmalı. Manual de ise Makine üzerinden gelen HOSTNAME ile AYNI olmalı.
Netbox VM veya Device Name i Makine üzerinden gelen HOSTNAME ile AYNI olmalı. 
Örn:Windowsdaki Makine Adı ile



#### Docker compose da versiyon uyuşmazlıkları sebebiyle şimdilik kullanım problemli !

example dosyalarını kopyalarak içindeki ayarları yapınız.

##### 1.Git clone
```

```


##### logs klasöründe chmod ve chown unutma!
```
sudo chown -R zabbix:zabbix path/to/ansible/logs
chmod -R 775 path/to/ansible/logs
```

##### Zabbix-sender kurmayı unutma !
```
apt-get update && apt-get install zabbix-sender -y
```






##### vault encrypt konteyner içinden çalıştır kopyala ve all.yml ye yapıştır  
```
docker exec -it ansible_konteyner_adı bash
```
```
ansible-vault encrypt_string --vault-password-file .vault_pass 'sifrelenecek_parola' --name 'ansible_password'
```


##### Update from Git 
```

```


Mustafa KALAYCI 
@Hikmet Bilgisayar Ltd.Şti. / KONYA
www.hikmet.com.tr