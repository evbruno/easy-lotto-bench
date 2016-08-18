#!/bin/bash

bundle exec unicorn -c ./config/unicorn-w1.rb -E production
