#!/usr/bin/env bash

echo "Running NGINX uninstall ..."

if ! type nginx &> /dev/null ; then
  echo "NGINX NOT installed... exiting"
  exit 0
fi

yum remove -y nginx
