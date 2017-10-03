# Project laboratory

Project laboratory is providing a virtual environment by vagrant.

## 1. Download needed software

**Get Provider:**

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) 

Suggestion to use libvirt as vagrant provider in linux, for mac & windows, VirtualBox could be a good solution.

**Get Vagrant:**

[Download Vagrant](https://www.vagrantup.com/downloads.html) 

## 2. Get laboratory running

**Prepare box:**

~~~bash
# vagrant box add centos/7
~~~

**Turn on laboratory**

~~~bash
# cd laboratory
# vagrant up
~~~

**Destroy laboratory**

~~~bash
# cd laboratory
# vagrant destroy
~~~

## 3. Once laboratory Ready

**Environment:**

|hostname|eth0|eth1|eth2 & eth3|
|-|-|-|-|
|lab.example.com|Vagrant default|172.25.0.254|192.168.0.254|
|server.example.com|Vagrant default|172.25.0.11|192.168.0.111/112|
|desktop.example.com|Vagrant default|172.25.0.10|192.168.0.101/102|

**NTP & DNS Server:**

lab.example.com

**Resolving DNS service:**

|IP Address|A Record|MX Record|
|-|-|-|
|172.25.0.254|lab.example.com|-|
|172.25.0.11|server.example.com|server.example.com|
|172.25.0.11|www.example.com|-|
|172.25.0.11|webapp.example.com|-|
|172.25.0.10|desktop.example.com|desktop.example.com|

**CA Certificate:**
http://lab.example.com/pub/example-ca.crt

**TLS certificate:**
http://lab.example.com/pub/tls/certs

**TLS private key:**
http://lab.example.com/pub/tls/private


**ldap & kerberos Configure:**

**TLS:** http://lab.example.com/pub/EXAMPLE-CA-CRT

**Server:** lab.example.com

**Base DN:** dc=example,dc=com

**Realm:** EXAMPLE.COM

**kdc:** lab.example.com

**Admin Server:** lab.example.com

**Keytab files:** http://lab.example.com/pub/keytabs

**ldap User:**

|Username|Password|Home directory|
|-|-|-|
|bruce|kerberos|/home/guests/bruce/|
|charles|kerberos|/home/guests/charles/|
|loki|kerberos|/home/guests/loki/|
|peter|kerberos|/home/guests/peter/|
|steve|kerberos|/home/guests/steve/|

**NFS Server:**

lab.example.com:/home/guests 172.25.0.0/255.255.255. 0

**Go ahead:**

~~~bash
# cd laboratory
# ssh -i .ssh/id_rsa root@server.example.com
# ssh -i .ssh/id_rsa root@desktop.example.com
~~~

## 4. Thanks

**Many thanks to those great Open Source Projects. We standing on the shoulders of giants.**

[Oracle VM VirtualBox](https://www.virtualbox.org/)

[Vagrant by HashiCorp](https://www.vagrantup.com/)

[CentOS Project](https://www.centos.org/)

[Parsedown](http://parsedown.org/)

**How can I help?**

Use it, star it, share it.
