# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs'][configs['configs']['use']]

Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 4443

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: vagrant_config['public_ip']

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder "./", "/var/www/html", :owner => "apache", :group => "apache"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  # 
  
  config.vm.provision :shell, path: "provision.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
  end

  # Port forwarding using the plugin (vagrant-triggers)
  config.trigger.after [:provision, :up, :reload] do
      system('echo "
        rdr pass on lo0 inet proto tcp from any to '+vagrant_config['public_ip']+' port 80 -> '+vagrant_config['public_ip']+' port 8080
        rdr pass on lo0 inet proto tcp from any to '+vagrant_config['public_ip']+' port 443 -> '+vagrant_config['public_ip']+' port 4443
        " | sudo pfctl -ef -; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 4443 & Enabling pf"'
      )
  end

  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
  end

end
