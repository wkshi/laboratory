#!/bin/bash
# Install related packages.. add loop in case network not well
while true; do
    yum --enablerepo=updates clean metadata
    yum install bind bind-utils -y
    if [ $? == '0' ]; then 
        break
    fi
done
# Configure bind
sed -i -e "/listen-on port 53/s/};/172.25.0.254;};/g" -e "/allow-query/s/};/172.25.0.0\/24;};/g" /etc/named.conf
cat >> /etc/named.rfc1912.zones <<EOF
zone "example.com" IN {
        type master;
        file "example.com.zone";
        allow-update { none; };
};

zone "0.25.172.in-addr.arpa" IN {
        type master;
        file "172.25.0.zone";
        allow-update { none; };
};

EOF
cat >> /var/named/example.com.zone <<EOF
\$TTL 1D
example.com.     IN SOA  lab.example.com. root.lab.example.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
@                       IN      NS      lab.example.com.
@                       IN      MX      10      lab.example.com.

example.com.            IN      A       172.25.0.254
lab.example.com.        IN      A       172.25.0.254

server                  IN      A       172.25.0.11
server.example.com.     IN      MX      10      server.example.com.
s                       IN      CNAME   server.example.com.
www                     IN      CNAME   server.example.com.
webapp                  IN      CNAME   server.example.com.

desktop                 IN      A       172.25.0.10
desktop                 IN      MX      10      desktop.example.com.
d                       IN      CNAME   desktop.example.com.

EOF
cat >> /var/named/172.25.0.zone <<EOF
\$TTL 1D
0.25.172.in-addr.arpa.  IN SOA  lab.example.com. root.lab.example.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
@                       IN      NS      lab.example.com.
254                     IN      PTR     lab.example.com.

11                      IN      PTR     server.example.com.
10                      IN      PTR     desktop.example.com.

EOF
chgrp named -R /var/named
restorecon -rv /var/named
# Enable & start
systemctl enable named
systemctl start named
# Configure firewall
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
