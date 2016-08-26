#!/usr/bin/env bash

echo "Running post install ..."

SHARED_SOCKET_DIR='/var/run/shared'

if sudo mkdir $SHARED_SOCKET_DIR > /dev/null 2>&1 ; then
  sudo chown "$USER:" /var/run/shared
  echo "Socket directory created: $SHARED_SOCKET_DIR"
else
  echo "Socket directory already exists: $SHARED_SOCKET_DIR"
fi

cd /webapp

rm -rf .bundle
bundle install --quiet
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed

rvm rvmrc warning ignore allGemfiles

echo "Yeyyyy! App is ready ! (= "
