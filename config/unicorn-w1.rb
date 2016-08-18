# Set the working application directory
app_dir = "/webapp"

working_directory "#{app_dir}"

# Unicorn PID file location
pid "#{app_dir}/pids/unicorn.pid"

# Path to logs
stderr_path "#{app_dir}/log/unicorn.stdout.log"
stdout_path "#{app_dir}/log/unicorn.stderr.log"

# Unicorn socket
listen "/var/run/shared/easy-lotto.sock", :backlog => 64

# Number of processes
worker_processes 1

# Time-out
timeout 30

preload_app true
