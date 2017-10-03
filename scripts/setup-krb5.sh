#!/bin/bash
# Install related packages.. add loop in case network not well
while true; do
    yum install krb5-server krb5-libs krb5-workstation -y
    if [ $? == '0' ]; then
        break
    fi
done
# Add kerberos user
MASTERPW=not_a_good_idea
USERPW=kerberos
LIST=(bruce charles loki peter steve)
sed -i "/default_realm/s/^#//" /etc/krb5.conf
/usr/sbin/kdb5_util create -P "${MASTERPW}" -s
for i in ${LIST[@]} ; do
    UNAME=$(printf %s ${i})
    echo "add_principal -pw ${USERPW} ${UNAME}" | kadmin.local
done
# Add kerberos keytab
mkdir -p /var/www/html/pub/keytabs
DESKTOP=desktop.example.com
SERVER=server.example.com
DESKTOPKT=/var/www/html/pub/keytabs/desktop.keytab
SERVERKT=/var/www/html/pub/keytabs/server.keytab
# Setup principals
for PRINC in host/${SERVER} host/${DESKTOP} nfs/${SERVER} nfs/${DESKTOP}; do
  echo "addprinc -randkey -clearpolicy ${PRINC}" | kadmin.local
done
# Create keytabs
echo "ktadd -k ${SERVERKT} host/${SERVER} nfs/${SERVER}" | kadmin.local
echo "ktadd -k ${DESKTOPKT} host/${DESKTOP} nfs/${DESKTOP}" | kadmin.local
chmod 644 /var/www/html/pub/keytabs/*
# Enable & start
systemctl enable krb5kdc.service
systemctl start krb5kdc.service
# Configure firewall
firewall-cmd --permanent --add-service=kerberos
firewall-cmd --reload
