# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/7"
  config.vm.provision "shell", path: "scripts/setup-common.sh"

  config.vm.define "lab" do |lab|
    lab.vm.hostname = "lab.example.com"
    lab.vm.network "private_network", ip: "172.25.0.254"
    lab.vm.network "private_network", ip: "192.168.0.254"
    lab.vm.provision :shell, path: "scripts/setup-lab.sh"
    lab.vm.provision :shell, path: "scripts/setup-dns.sh"
    lab.vm.provision :shell, path: "scripts/setup-tls-ca.sh"
    lab.vm.provision :shell, path: "scripts/setup-sslcerts.sh"
    lab.vm.provision :shell, path: "scripts/setup-ldap.sh"
    lab.vm.provision :shell, path: "scripts/setup-krb5.sh"
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "server.example.com"
    server.vm.network "private_network", ip: "172.25.0.11"
    server.vm.network "private_network", ip: "192.168.0.111"
    server.vm.network "private_network", ip: "192.168.0.112"
    server.vm.provision :shell, path: "scripts/setup-no-lab.sh"
  end

  config.vm.define "desktop" do |desktop|
    desktop.vm.hostname = "desktop.example.com"
    desktop.vm.network "private_network", ip: "172.25.0.10"
    desktop.vm.network "private_network", ip: "192.168.0.101"
    desktop.vm.network "private_network", ip: "192.168.0.102"
    desktop.vm.provision :shell, path: "scripts/setup-no-lab.sh"
  end

  #config.vm.provider "libvirt" do |v|
  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
  end

end
