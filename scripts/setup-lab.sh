#!/bin/bash
# Configure lab interface
# Make sure 172.25.0.254 & 192.168.0.254 existing
# eth0 public network
# eth1 172.25.0.254
# eth2 192.168.0.254
sed -i /^NM_CONTROLLED/s/no/yes/g /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i /^NM_CONTROLLED/s/no/yes/g /etc/sysconfig/network-scripts/ifcfg-eth2
systemctl restart network NetworkManager
# Configure httpd 
yum install httpd php -y 
cp /vagrant/materials/html/Parsedown.php /var/www/html/Parsedown.php
cp /vagrant/materials/html/index.php /var/www/html/index.php
cp /vagrant/README.md /var/www/html/README.md
mkdir -p /var/www/html/pub/
systemctl enable httpd
systemctl start httpd
# Configure NFS
systemctl enable nfs-server.service
systemctl start nfs-server.service
# Configure NTP
timedatectl set-timezone Asia/Shanghai
systemctl enable chronyd.service
systemctl start chronyd.service
# Configure firewall for above services
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=ntp
firewall-cmd --permanent --add-port=123/udp
firewall-cmd --permanent --add-port=323/udp
firewall-cmd --reload
