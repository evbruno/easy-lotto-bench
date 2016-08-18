#!/usr/bin/env bash

echo "Installing ruby. ARGS: $@"

echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

source $HOME/.rvm/scripts/rvm

# TODO fixme
# if [ $# -gt $MIN_ARGS ]; then
if rvm list | grep -Fq "$1" ; then
  echo "RVM ruby $1 already installed... exiting"
  exit 0
fi

rvm use --default --install $1

shift

if (( $# ))
then gem install $@
fi

rvm cleanup all
