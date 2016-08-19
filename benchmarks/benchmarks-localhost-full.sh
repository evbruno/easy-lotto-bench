#!/usr/bin/env bash

#######################################

# BRANCHES=('puma-1w' 'puma-2w' 'puma-3w' 'unicorn-1w' 'unicorn-2w' 'unicorn-3w' 'passenger-1w' 'passenger-2w' 'passenger-3w')
# VMS=('centos' 'ubuntu')
# BENCHMARK_REQUESTS=16000
# BENCHMARK_CONCURRENCY=(1 2 4 8 16 24)

BRANCHES=('master')
VMS=('centos')
BENCHMARK_REQUESTS=100
BENCHMARK_CONCURRENCY=(1)

SERVER_URL="http://localhost:8090/"

#######################################

ORIGINAL_DIR=$(pwd)

vagrant_dir() {
  cd "$ORIGINAL_DIR/../vagrant"
}

benchmark_dir() {
  cd $ORIGINAL_DIR
}

start_vm() {
  vm=$1
  echo "Booting VM: $vm"
  vagrant_dir
  eval "./up-$vm.sh"
  benchmark_dir
}

stop_vm() {
  vm=$1
  echo "Shutting down VM: $vm"
  vagrant_dir
  eval "./down-$vm.sh"
  benchmark_dir
}

benchmark() {
  for concurrency in  ${BENCHMARK_CONCURRENCY[@]}; do
    # cmd="ab -n $BENCHMARK_REQUESTS -c $concurrency $SERVER_URL/benchmark/task1"
    cmd="ab -n $BENCHMARK_REQUESTS -c $concurrency $SERVER_URL/benchmark/task1"
    echo "Benchmarking: $cmd"
    eval $cmd
  done
}

main() {

  for vm in ${VMS[@]}; do
    start_vm $vm

    for branch in ${BRANCHES[@]} ; do
      cd "$ORIGINAL_DIR/.."
      echo "    branch: $branch $(pwd)"

      cap production deploy
      cap production easy:start

      benchmark

      cap production easy:stop

    done

    stop_vm $vm
  done

}

#######################################

main
