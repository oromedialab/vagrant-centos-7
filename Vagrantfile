# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

require 'ipaddr'
require 'yaml'

dirname       = File.basename(Dir.getwd)
DOCUMENT_ROOT = '/var/www/html/'+dirname

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs']

# allow valid ipv4 address for box_ip
if !!(IPAddr.new(vagrant_config['box_ip']) rescue nil).nil?
  abort('ERROR : Invalid box_ip ['+vagrant_config['box_ip']+'], define valid IPV4 address in config.yaml before continuing with the setup')
end;

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Config
  config.vm.box = vagrant_config['box']
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 4443
  config.vm.network "private_network", ip: vagrant_config['box_ip']
  config.vm.synced_folder '.', DOCUMENT_ROOT
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", vagrant_config['memory']]
  end
  # Provisions
  config.vm.provision :shell, path: "provision.sh"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
  end
  # Port forwarding using the plugin (vagrant-triggers)
  config.trigger.after [:provision, :up, :reload] do
      system('echo "
        rdr pass on lo0 inet proto tcp from any to '+vagrant_config['box_ip']+' port 80 -> '+vagrant_config['box_ip']+' port 8080
        rdr pass on lo0 inet proto tcp from any to '+vagrant_config['box_ip']+' port 443 -> '+vagrant_config['box_ip']+' port 4443
        " | sudo pfctl -ef -; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 4443 & Enabling pf"'
      )
  end
  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
  end
end