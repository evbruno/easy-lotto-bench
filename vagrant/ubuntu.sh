#!/usr/bin/env bash

echo "Running ubuntu pre install ... "

if type nodejs &> /dev/null ; then
  echo 'NODEJS already installed... exiting'
  exit 0
fi

apt-get update && apt-get install -y curl git vim nodejs libpq-dev wget nmon htop

# dd if=/dev/zero of=/swap bs=1M count=1024
fallocate -l 1G /swapfile
chmod 600 /swapfile

mkswap /swapfile
swapon /swapfile
swapon --summary
