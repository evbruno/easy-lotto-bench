#!/bin/bash

# bundle exec puma -C config/puma-w1.rb
# bundle exec puma -C config/puma-w2.rb
# bundle exec unicorn -c ./config/unicorn-w1.rb -E production
# bundle exec unicorn -c ./config/unicorn-w1.rb -E production

# default (=
rails server -p 8080 -b 0.0.0.0 -e production
