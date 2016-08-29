threads 32, 32
workers 1
preload_app!

environment 'production'

# bind 'tcp://0.0.0.0:3000'
# bind 'unix:///var/run/shared/easy-lotto.sock'

app_dir = File.expand_path(File.dirname(__FILE__) + '/..')

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/pids/puma.pid"
state_path "#{app_dir}/pids/puma.state"

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
