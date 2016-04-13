# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'ipaddr'
require 'yaml'

VAGRANTFILE_API_VERSION = '2'

CURRENT_DIR    = File.dirname(File.expand_path(__FILE__))
DIRNAME        = File.basename(Dir.getwd)
CONFIG_FILE    = CURRENT_DIR+'/config.yaml'
CONFIG         = YAML.load_file(CONFIG_FILE)
DEFAULT_CONFIG = CONFIG['default']
VAGRANT_CONFIG = CONFIG['vagrant']
MYSQL_CONFIG   = CONFIG['mysql']
GIT_CONFIG     = CONFIG['git']
HTTPD_CONFIG   = CONFIG['httpd']
SYNC_FOLDER    = VAGRANT_CONFIG['sync_folder_path']
SYNC_FOLDER.sub! ':DIRNAME', DIRNAME
SCRIPT_PATH    = CURRENT_DIR+'/scripts/'
DOCUMENT_ROOT  = HTTPD_CONFIG['document_root']
DOCUMENT_ROOT.sub! ':DIRNAME', DIRNAME

# validate box_ip
if !!(IPAddr.new(VAGRANT_CONFIG['box_ip']) rescue nil).nil?
  abort('ERROR : Invalid box_ip ['+VAGRANT_CONFIG['box_ip']+'], define valid IPV4 address in config.yaml before continuing with the setup')
end;

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # config
  config.vm.box = VAGRANT_CONFIG['box']
  config.vm.network "forwarded_port", guest: 80, host: VAGRANT_CONFIG['http_port']
  config.vm.network "forwarded_port", guest: 443, host: VAGRANT_CONFIG['https_port']
  config.vm.network "private_network", ip: VAGRANT_CONFIG['box_ip']
  config.vm.synced_folder '.', SYNC_FOLDER, nfs: true
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", VAGRANT_CONFIG['memory']]
  end

  # provisions
  config.vm.provision :shell, path: SCRIPT_PATH + "pre-configure.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "wget.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "zip.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "oh-my-zsh.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "git.sh", args: [GIT_CONFIG['name'], GIT_CONFIG['email']]
  config.vm.provision :shell, path: SCRIPT_PATH + "httpd.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "mysql.sh", args: [MYSQL_CONFIG['username'], MYSQL_CONFIG['password'], MYSQL_CONFIG['database']]
  config.vm.provision :shell, path: SCRIPT_PATH + "php.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "composer.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "puppet.sh"
  DEFAULT_CONFIG['set_env'].each do |key, value|
    config.vm.provision :shell, path: SCRIPT_PATH + "environment-variables.sh", args: [key, value]
  end
  config.vm.provision :shell, path: SCRIPT_PATH + "bash.sh"
  config.vm.provision :shell, path: SCRIPT_PATH + "post-configure.sh", args: [DOCUMENT_ROOT, HTTPD_CONFIG['user'], HTTPD_CONFIG['group']]

  # Port forwarding using the plugin (vagrant-triggers)
  config.trigger.after [:provision, :up, :reload] do
      system('echo "
        rdr pass on lo0 inet proto tcp from any to '+VAGRANT_CONFIG['box_ip']+' port 80 -> '+VAGRANT_CONFIG['box_ip']+' port '+VAGRANT_CONFIG['http_port']+'
        rdr pass on lo0 inet proto tcp from any to '+VAGRANT_CONFIG['box_ip']+' port 443 -> '+VAGRANT_CONFIG['box_ip']+' port '+VAGRANT_CONFIG['https_port']+'
        " | sudo pfctl -ef -; echo "==> Fowarding Ports: 80 -> '+VAGRANT_CONFIG['http_port']+', 443 -> '+VAGRANT_CONFIG['https_port']+' & Enabling pf"'
      )
  end

  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
  end

end