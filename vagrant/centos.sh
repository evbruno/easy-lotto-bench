#!/usr/bin/env bash

if type node &> /dev/null ; then
  echo "NODE-JS already installed... exiting"
  exit 0
fi

curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

yum install -y nodejs wget git
