#!/usr/bin/env bash

echo "Running post install ..."

SHARED_SOCKET_DIR='/var/run/shared'

if sudo mkdir $SHARED_SOCKET_DIR > /dev/null 2>&1 ; then
  sudo chown "$USER:" /var/run/shared
  echo "Socket directory created: $SHARED_SOCKET_DIR"
else
  echo "Socket directory already exists: $SHARED_SOCKET_DIR"
fi

if [ -z "$SECRET_KEY_BASE" ] ; then

  if grep -q 'export SECRET_KEY_BASE' ~/.bashrc ; then
    echo 'Your key is already set to your ~/.bashrc file. Please, run your bash (login) again...'
  else
    _SECRET=$(RAILS_ENV=production rake secret)
    echo "export SECRET_KEY_BASE=$_SECRET" >> ~/.bashrc
    echo "Your secret key is set to your file ~/.bashrc file. Please, run your bash (login) again..."
  fi

else

  echo 'Secret key already exists!'

fi

cd /webapp

if [ $# -ge 1 ] ; then
  echo "Running gem install with $@"
  gem install $@
else
  echo "No arguments passed... Skipping 'gem install'"
fi

bundle install

echo "Yeyyyy! App is ready ! (= "
