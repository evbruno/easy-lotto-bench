#!/usr/bin/env bash

if type vim &> /dev/null ; then
  echo 'VIM already installed... exiting'
  exit 0
fi

apt-get update && apt-get install -y curl git vim nodejs libpq-dev wget
