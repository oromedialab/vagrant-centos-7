# @TODO
- Fix environment variable reading issue in PHP
- Allow to change apache user and group from config file (User apache, Group apache) - httpd.conf (DONE)
- Fix mod_rewrite issue (Change AllowOverride None to AllowOverride All) - http://stackoverflow.com/questions/30855651/how-to-enable-mod-rewrite-on-apache-2-4 (DONE)
- Install oh-my-zsh
- Add commands
	- mysql.login
	- [ps aux | egrep '(apache|httpd)'] - find apache user
	- orm.db.reload
	- system commands (g, goto...)
- Improve
	- https://github.com/aaronlord/vagrant/blob/master/scripts/base.sh