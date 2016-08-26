#!/usr/bin/env bash

PG_VERSION=$1

echo "Installing postgresql-$PG_VERSION (apt)"

if type psql &> /dev/null ; then
  echo 'PSQL already installed... exiting'
  exit 0
fi

# Install

echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
apt-get update
apt-get install -y "postgresql-$PG_VERSION"

# Dev only

cd "/etc/postgresql/$PG_VERSION/main"
echo "Current dir: $(pwd)"

cp postgresql.conf postgresql.conf.orig
sed -i.bak "s/ssl.*=.*/#ssl=off/g" postgresql.conf
sed -i.bak "s/^ssl_/#ssl_/g" postgresql.conf
sed -i.bak "s/#listen_addresses.*=.*'.*'/listen_addresses='*'/g" postgresql.conf

cp pg_hba.conf pg_hba.conf.orig
echo 'host all all 0.0.0.0/0 trust' > pg_hba.conf

/etc/init.d/postgresql restart
