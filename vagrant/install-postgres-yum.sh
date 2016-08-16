#!/usr/bin/env bash

if type psql &> /dev/null ; then
  echo 'PSQL already installed... exiting'
  exit 0
fi

# echo "Argument '$1' will be ignored..."
PG_VERSION='9.5'

# Adding PostgreSQL Yum Repository

rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm

# Installing PostgreSQL Server

yum install -y postgresql95-server postgresql95-devel postgresql95-contrib postgresql95 libpqxx-devel

# Initializing PGDATA

/usr/pgsql-9.5/bin/postgresql95-setup initdb

# Start PostgreSQL Server

systemctl start "postgresql-$PG_VERSION"
systemctl enable "postgresql-$PG_VERSION"

# Installing PG gem

su - vagrant -c 'gem install pg -- --with-pg-config=/usr/pgsql-9.5/bin/pg_config'

# Dev only

cd "/var/lib/pgsql/$PG_VERSION/data/"
echo "Current dir: $(pwd)"

cp postgresql.conf postgresql.conf.orig
sed -i.bak "s/ssl.*=.*/#ssl=off/g" postgresql.conf
sed -i.bak "s/^ssl_/#ssl_/g" postgresql.conf
sed -i.bak "s/#listen_addresses.*=.*'.*'/listen_addresses='*'/g" postgresql.conf

cp pg_hba.conf pg_hba.conf.orig
echo 'host  all   all   ::1/128    trust' > pg_hba.conf
echo 'host  all   all   0.0.0.0/0  trust' >> pg_hba.conf

# restarting...

systemctl stop "postgresql-$PG_VERSION"
systemctl start "postgresql-$PG_VERSION"
