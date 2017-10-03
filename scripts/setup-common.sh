#!/bin/bash
# Inject public key
if [ ! -d /root/.ssh ]; then
    mkdir /root/.ssh
fi
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2RYLjzfcYed9PsJ5DWYIlsXSiTMvYqALCPOkByDgl/DniBTDTNskpqGkYHSjuAJiZUeIBDLhMhNxwDfb6cKsrokXijxrbXJi9yhkTCJnNlDEV6l6bsqkuGyzQBbzNdLX6CWcDtQHQts+zbttpYzdM2jeGIpGs1aJWWqEd49ocba4YM/5ypPr9ufqnysL0SzvOSSx8+tEv069aoOEYcpLbvsokJU/C4J0E6GCmPaM9s+PIW+jKkW1BohgAzcBHTo3Czbo0VRaVbdnKsx0lS+VmcP3THLSlXV7dIwWRylt0gp1IT4Kg3sZbqEPPt+XkKMK4IYBcfUxmrcn0ZIyV/u3v wkshi@wkshi.cc" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
# Set password
echo redhat | passwd --stdin root &> /dev/null
# Open passwd auth
sed -i "/PasswordAuthentication no/d" /etc/ssh/sshd_config
systemctl restart sshd
# Use 163 repo
mkdir /etc/yum.repos.d/backup/
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo 
yum clean all
# Enable firewalld
systemctl enable firewalld
systemctl start firewalld
