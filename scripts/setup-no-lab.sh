#!/bin/bash
# sed -i /^ONBOOT/s/yes/no/g /etc/sysconfig/network-scripts/ifcfg-eth0
# Configure server & desktop 's interface
# Add DNS to lab/172.25.0.254
sed -i "/^NETMASK/a\DNS1=172.25.0.254" /etc/sysconfig/network-scripts/ifcfg-eth1
# Make sure 172.25.0.1[01] & 192.168.0.1[01][12] exist 
#      server         desktop
# eth0 public network public network
# eth1 172.25.0.11    172.25.0.10
# eth2 192.168.0.111  192.168.0.101
# eth3 192.168.0.112  192.168.0.102
sed -i /^NM_CONTROLLED/s/no/yes/g /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i /^NM_CONTROLLED/s/no/yes/g /etc/sysconfig/network-scripts/ifcfg-eth2
sed -i /^NM_CONTROLLED/s/no/yes/g /etc/sysconfig/network-scripts/ifcfg-eth3
systemctl restart network NetworkManager
# Make sure internal dns the first
sed -i /main/a\dns=none /etc/NetworkManager/NetworkManager.conf
sed -i -e "/172.25.0.254/d" -e "/search/a\nameserver 172.25.0.254" -e "s/NetworkManager/wkshi/g" /etc/resolv.conf
