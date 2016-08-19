#!/usr/bin/env bash

#######################################

# BRANCHES=('puma-1w' 'puma-2w' 'puma-3w' 'unicorn-1w' 'unicorn-2w' 'unicorn-3w' 'passenger-1w' 'passenger-2w' 'passenger-3w')
# VMS=('centos' 'ubuntu')
# BENCHMARK_REQUESTS=16000
# BENCHMARK_CONCURRENCY=(1 2 4 8 16 24)

BRANCHES=('master' 'puma-1w')
VMS=('centos' 'ubuntu')
BENCHMARK_REQUESTS=100
BENCHMARK_CONCURRENCY=(1)

SERVER_URL="http://localhost:3000"

#######################################

ORIGINAL_DIR=$(pwd)

bench_dir() {
  cd $ORIGINAL_DIR
}

start_vm() {
  vm=$1
  echo "Booting VM: $vm"
  cd ../vagrant
  eval "./up-$vm.sh"
  bench_dir
}

stop_vm() {
  vm=$1
  echo "Shutting down VM: $vm"
  cd ../vagrant
  eval "./down-$vm.sh"
  bench_dir
}

benchmark() {
  for concurrency in  ${BENCHMARK_CONCURRENCY[@]}; do
    cmd="ab -n $BENCHMARK_REQUESTS -c $concurrency $SERVER_URL/benchmark/task1"
    echo "Benchmaring: $cmd"
    eval $cmd
  done
}

main() {

  for vm in ${VMS[@]}; do
    start_vm $vm

    for branch in ${BRANCHES[@]} ; do
      echo "    branch: $branch"
    done

    stop_vm $vm
  done

}

#######################################

main
