# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility).
Vagrant.configure("2") do |config|
	# For a complete reference, please see the online documentation at
	# https://docs.vagrantup.com.

	# You can search for boxes at https://atlas.hashicorp.com/search.
	config.vm.box = "bento/ubuntu-16.04"

	config.vm.provision "file", source: "kernel", destination: "$HOME/kernel"

	config.vm.provision "shell", inline: <<-SHELL
		if ! which puppet; then
			apt-get update
			apt-get install -y puppet-common
		fi
	SHELL

	# TODO Must delete the the directory above
	config.vm.provision "puppet" do |puppet|
		puppet.options = "--verbose --debug --parser future"
		puppet.manifests_path = "puppet/manifests/"
		puppet.module_path = "puppet/modules/"
	end

	config.ssh.forward_x11 = true

	config.vm.provider "virtualbox" do |v|

	end
end

