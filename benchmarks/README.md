# Benchmarks

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
