threads 8, 32
workers 1
preload_app!

environment 'production'

bind 'unix:///var/run/shared/easy-lotto.sock'

app_dir = "/webapp"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/pids/puma.pid"
state_path "#{app_dir}/pids/puma.state"
