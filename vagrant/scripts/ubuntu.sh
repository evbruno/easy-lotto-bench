#!/usr/bin/env bash

echo "Running ubuntu pre install ... "

if type nodejs &> /dev/null ; then
  echo 'NODEJS already installed... exiting'
  exit 0
fi

apt-get update && apt-get install -y curl git vim nodejs libpq-dev wget nmon htop
