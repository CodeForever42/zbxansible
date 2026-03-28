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
sudo usermod -aG docker zabbix
```

#### Docker compose versiyon uyuşmazlıkları sebebiyle şimdilik kullanım dışıdır !

example dosyalarını kopyalarak içindeki ayarları yapınız.

##### 2. Git clone
```
cd /opt
```
```
git clone https://github.com/codeforever42/zbxansible.git ansible
```
```
sudo chown -R zabbix:zabbix /opt/ansible
```
```
cp /opt/ansible/ansible.example.cfg /opt/ansible/ansible.cfg
```
```
cp /opt/ansible/docker-compose.example.yml /opt/ansible/docker-compose.yml
```
```
cp /opt/ansible/.vault_pass.example /opt/ansible/.vault_pass 
```
```
cp /opt/ansible/group_vars/all.example.yml /opt/ansible/group_vars/all.yml 
```
```
cp /opt/ansible/inventory/netboxinv4win.sample.yml /opt/ansible/inventory/netboxinv4win.yml 
```


##### 3. logs klasöründe chmod ve chown unutma! (bu madde yapılmadığında da çalıştı )
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
docker compose up -d
docker exec -it ansible_test bash
```
```
ansible-vault encrypt_string --vault-password-file .vault_pass 'sifrelenecek_parola' --name 'ansible_password'
```


##### Update from Git 
```
cd /opt/ansible
git pull
```
```
#some tricky for local 
#not for use remote
git update-index --chmod=+x worker.sh
git commit -m "make worker.sh executable"
```

Mustafa KALAYCI 
@Hikmet Bilgisayar Ltd.Şti. / KONYA
www.hikmet.com.tr