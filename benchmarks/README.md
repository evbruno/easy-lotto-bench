# Benchmarks

**Follow these steps before you begin**

- start the first VM to follow the installation. Use `vagrant/up-centos.sh`
- copy your .pub key to allow ssh without password. Use `vagrant ssh-config` to confirm the ssh port. You can easilly copy your key with `ssh-copy-id vagrant@localhost -p 2200`. The password is `vagrant`
- run `down-centos.sh`
- do it again for other VMs...
- To test the *capistrano*, bring back any VM then run `cap production deploy:check`

## Localhost
### Vagrant (Virtualbox)

File: `./benchmarks-localhost-full.sh`

### Docker-Machine (Virtualbox)

```
docker-machine create --driver virtualbox --virtualbox-memory 512 --virtualbox-cpu-count 1 vbox-1cpu-512m
docker-machine create --driver virtualbox --virtualbox-memory 768 --virtualbox-cpu-count 1 vbox-1cpu-768m
docker-machine create --driver virtualbox --virtualbox-memory 1024 --virtualbox-cpu-count 1 vbox-1cpu-1024m
docker-machine create --driver virtualbox --virtualbox-memory 2048 --virtualbox-cpu-count 2 vbox-2cpu-2048m
```

## DigitalOcean

**TODO**

## EC2

**TODO**
