#!/usr/bin/env bash

echo "Running CentOS pre install ..."

if type node &> /dev/null ; then
  echo "NODE-JS already installed... exiting"
  exit 0
fi

# Enable EPEL Repository
# sudo su -c 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm'

rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm

# Update everything, once more.

# yum -y update

# not sure if we need this
# yum groupinstall -y development

# NodeJS
# curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

yum install -y nodejs git vim htop

# nmon

cd /tmp
wget http://sourceforge.net/projects/nmon/files/nmon16e_mpginc.tar.gz
tar -xzvf nmon16e_mpginc.tar.gz
chmod a+x nmon_x86_64_centos7
mv nmon_x86_64_centos7 /usr/bin/nmon
ln -s /usr/bin/nmon /usr/local/bin/nmon
