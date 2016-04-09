# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'ipaddr'
require 'yaml'

VAGRANTFILE_API_VERSION = '2'

CURRENT_DIR    = File.dirname(File.expand_path(__FILE__))
DIRNAME        = File.basename(Dir.getwd)
DOCUMENT_ROOT  = '/var/www/html/'+DIRNAME
CONFIG_FILE    = CURRENT_DIR+'/config.yaml'
CONFIGS        = YAML.load_file(CONFIG_FILE)
VAGRANT_CONFIG = CONFIGS['configs']['vagrant']
SCRIPT_PATH    = CURRENT_DIR+'/scripts/'

# validate box_ip
if !!(IPAddr.new(VAGRANT_CONFIG['box_ip']) rescue nil).nil?
  abort('ERROR : Invalid box_ip ['+VAGRANT_CONFIG['box_ip']+'], define valid IPV4 address in config.yaml before continuing with the setup')
end;

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # config
  config.vm.box = VAGRANT_CONFIG['box']
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 4443
  config.vm.network "private_network", ip: VAGRANT_CONFIG['box_ip']
  config.vm.synced_folder '.', DOCUMENT_ROOT
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", VAGRANT_CONFIG['memory']]
  end

  # provisions
  config.vm.provision :shell, path: SCRIPT_PATH + "pre-configure.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "wget.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "git.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "php.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "mysql.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "httpd.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "composer.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "puppet.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "post-configure.sh"

  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = 'puppet/manifests'
  # end
  # Port forwarding using the plugin (vagrant-triggers)
  config.trigger.after [:provision, :up, :reload] do
      system('echo "
        rdr pass on lo0 inet proto tcp from any to '+VAGRANT_CONFIG['box_ip']+' port 80 -> '+VAGRANT_CONFIG['box_ip']+' port 8080
        rdr pass on lo0 inet proto tcp from any to '+VAGRANT_CONFIG['box_ip']+' port 443 -> '+VAGRANT_CONFIG['box_ip']+' port 4443
        " | sudo pfctl -ef -; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 4443 & Enabling pf"'
      )
  end
  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
  end
end