# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "NASANOMICS" do |nasanomics|
    nasanomics.vm.box = "debian/jessie64"
    nasanomics.vm.provider "virtualbox" do |v| 
      v.customize ["modifyvm", :id, "--name", "nasanomics"]
    end 
    nasanomics.vm.network "forwarded_port", host: 8080, guest: 80
    nasanomics.vm.synced_folder "./vps/vagrant", "/vagrant"
    nasanomics.vm.provision :shell, path: "./vps/vagrant/provision.sh"
  end
end
