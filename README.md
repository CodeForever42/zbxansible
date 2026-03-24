## zbxansible
Zabbix üzerinden Action script ile Zabbix-Proxy de Ansible taskları çalıştıracağız.  
Burada envanter NetBox üzerinden API ile çekilmektedir.

Zabbix hostlarının Inventory kısmında ALIAS alanı NETBOX daki NAME ile AYNI olmalı.  
Inventory Manuel veya Automatic olduğu durumlarda edit edilebilir!  

##### > Proxy config dosyasında EnableRemoteCommand
```
 sudo nano /etc/zabbix/zabbix_proxy.conf
```
```
### Option: EnableRemoteCommands
#               Whether remote commands from Zabbix server are allowed.
#               0 - not allowed
#               1 - allowed
#
# Mandatory: no
# Default:
EnableRemoteCommands=1
```

##### 1. Docker Image pull
```
docker pull ghcr.io/codeforever42/ansible-runner:latest
```

#### Docker compose versiyon uyuşmazlıkları sebebiyle şimdilik kullanım dışıdır !

example dosyalarını kopyalarak içindeki ayarları yapınız.

##### 2. Git clone
```
cd /opt
git clone https://github.com/codeforever42/zbxansible.git ansible
sudo chown -R zabbix:zabbix /opt/ansible
```


##### 3. logs klasöründe chmod ve chown unutma!
```
sudo chown -R zabbix:zabbix /opt/ansible/logs
chmod -R 775 /opt/ansible/logs
```

##### 4. Zabbix-sender kurmayı unutma !
```
apt-get update && apt-get install zabbix-sender -y
```






##### 5. vault encrypt konteyner içinden çalıştır kopyala ve all.yml ye yapıştır  
```
# buraya container run eklenecek!!!!
docker exec -it ansible_konteyner_adı bash
```
```
ansible-vault encrypt_string --vault-password-file .vault_pass 'sifrelenecek_parola' --name 'ansible_password'
```


##### Update from Git 
```
cd /opt/ansible
git pull
```


Mustafa KALAYCI 
@Hikmet Bilgisayar Ltd.Şti. / KONYA
www.hikmet.com.tr