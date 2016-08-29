# Set the working application directory
app_dir = File.expand_path(File.dirname(__FILE__) + '/..')

working_directory "#{app_dir}"

# Unicorn PID file location
#pid "/var/run/shared/easy-lotto-server.pid"
pid "#{app_dir}/tmp/easy-lotto-server.pid"

# Path to logs
stderr_path "#{app_dir}/log/unicorn.stdout.log"
stdout_path "#{app_dir}/log/unicorn.stderr.log"

# Unicorn socket
# listen "/var/run/shared/easy-lotto.sock", :backlog => 1024
# listen "0.0.0.0:8080", :tcp_nopush => true

# Number of processes
worker_processes 3

# Time-out
timeout 30

preload_app true
