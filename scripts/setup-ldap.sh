#!/bin/bash
# Install related packages.. add loop in case network not well
while true; do
    yum install openldap openldap-servers openldap-clients openldap-devel -y
    if [ $? == '0' ]; then
        break
    fi
done
# Generate CA-signed TLS certificate for slapd.
( umask 077
sed -i -e "s/cacert.pem/example-ca.crt/g" -e "s/cakey.pem/example-ca.key/g" /etc/pki/tls/openssl.cnf
SUBJECT="/C=CN/ST=Shaanxi/L=Xi'an/O=Example, Inc./CN=lab.example.com"
openssl req -new -nodes -out /etc/pki/tls/certs/slapd.csr -keyout /etc/pki/tls/certs/slapd.key -subj "${SUBJECT}"
openssl ca -batch -in /etc/pki/tls/certs/slapd.csr -out /etc/pki/tls/certs/slapd.crt
( cat /etc/pki/tls/certs/slapd.key; echo; cat /etc/pki/tls/certs/slapd.crt ) > /etc/pki/tls/certs/slapd.pem
chown ldap /etc/pki/tls/certs/slapd.pem
rm -f /etc/pki/tls/certs/slapd.key /etc/pki/tls/certs/slapd.crt /etc/pki/tls/certs/slapd.csr
)
# Install directory tree
mv -f /etc/openldap/slapd.d /etc/openldap/slapd.d.bak
tar xf /vagrant/materials/ldap/slapd.d.tar -C /etc/openldap
chown -R ldap:ldap /etc/openldap/slapd.d/*
restorecon -R /etc/openldap/slapd.d
# Make sure listen on ldaps:///
sed -i 's|^SLAPD_URLS=.*$|SLAPD_URLS="ldapi:/// ldap:/// ldaps:///"|' /etc/sysconfig/slapd
# Make sure DB_CONFIG existing
touch /var/lib/ldap/DB_CONFIG
# Import basic DIT structure, users, and groups
slapadd -l /vagrant/materials/ldap/base.ldif
LIST=(bruce charles loki peter steve)
for i in ${LIST[@]} ; do
    let x=i+1700
    echo -e "dn: uid=${i},ou=People,dc=example,dc=com\nuid: ${i}\ncn: LDAP Test User ${i}\ngivenName: LDAP Test User\nsn: ${i}\nmail: ${i}@example.com\nobjectClass: person\nobjectClass: organizationalPerson\nobjectClass: inetOrgPerson\nobjectClass: posixAccount\nobjectClass: top\nobjectClass: shadowAccount\nuserPassword: {SSHA}2RxVB3Cb+JZxqLDD4EucbGKEew9bhXNB\nshadowLastChange: 12797\nshadowMax: 99999\nshadowWarning: 7\nloginShell: /bin/bash\nuidNumber: ${x}\ngidNumber: ${x}\nhomeDirectory: /home/guests/${i}\ngecos: LDAP Test User ${i}" | slapadd
    echo -e "dn: cn=${i},ou=Group,dc=example,dc=com\nobjectClass: posixGroup\nobjectClass: top\ncn: ${i}\nuserPassword: {crypt}x\ngidNumber: ${x}" | slapadd
done
chown ldap /var/lib/ldap/*
# Set up LDAP user home directories.
for i in ${LIST[@]} ; do
    let x=i+1700
    mkdir -p /home/guests/${i}
    cp -a /etc/skel/.[!.]* /home/guests/${i}
    chmod 700 /home/guests/${i}
    chown -R ${x}:${x} /home/guests/${i}
done
echo "/home/guests    172.25.0.0/255.255.255.0(rw)" >> /etc/exports
exportfs -r
for i in ${LIST[@]} ; do
    echo "${i} - maxlogins 0" >> /etc/security/limits.conf
done
# Enable & start
systemctl enable slapd.service
systemctl start slapd.service
# Configure firewall
firewall-cmd --permanent --add-service=ldap
firewall-cmd --permanent --add-service=ldaps
firewall-cmd --reload
