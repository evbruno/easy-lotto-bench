#!/usr/bin/env bash

if type rvm &> /dev/null ; then
  echo 'RVM already installed... exiting'
  exit 0
fi

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s $1
