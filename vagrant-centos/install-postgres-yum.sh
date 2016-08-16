# Adding PostgreSQL Yum Repository

rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm

# Installing PostgreSQL Server

yum install -y postgresql95-server postgresql95-devel postgresql95-contrib postgresql95

# Initializing PGDATA

/usr/pgsql-9.5/bin/postgresql95-setup initdb

# Start PostgreSQL Server

systemctl start postgresql-9.5
systemctl enable postgresql-9.5

