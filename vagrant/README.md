# Vagrant

:computer: Tries to mimic a tiny/micro server to deploy our application.

```bash
# booting up
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-librarian-chef-nochef
$ vagrant up

# box ssh
$ vagrant ssh

# halting / starting
$ vagrant halt
$ vagrant up --provision
$ vagrant reload --provision

# if you get some error like : "vboxsf" file system is not available
# try this commands
$ vagrant plugin install vagrant-vbguest
$ vagrant reload

# start the Postgresql
$ vagrant ssh
# Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.13.0-93-generic x86_64)
#
$ sudo /etc/init.d/postgresql restart
# ensure everything is fine:
$ psql -U postgres -h localhost
#psql (9.5.4)
#Type "help" for help.
#
#postgres=#
```
