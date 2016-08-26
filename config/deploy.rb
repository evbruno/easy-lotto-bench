# config valid only for current version of Capistrano
lock '3.6.0'

server '127.0.0.1', port: 2222, user: 'vagrant', primary: true, roles: %w{web app}

set :user,            'vagrant'
set :application,     'easy-loto-bench'
set :scm,             :git
set :repo_url,        'https://github.com/evbruno/easy-lotto-bench.git'

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :branch, ENV['BRANCH'] if ENV['BRANCH']

namespace :easy do

  # set :server_pid, -> { File.join(current_path, "tmp", "pids", "server.pid") }
  # set :server_pid, -> { File.join(current_path, "tmp", "server.pid") }
  set :server_pid, -> { '/var/run/shared/easy-lotto-server.pid' }

  # https://github.com/tablexi/capistrano3-unicorn/blob/master/lib/capistrano3/tasks/unicorn.rake

  desc 'Start Rails Server'
  task :start do
    on roles :all do
      info "Starting rails server..."
      invoke 'easy:bundle_exec', "rails server -d -p 8080 -e production -b 0.0.0.0 --pid #{fetch(:server_pid)}"
    end
  end

  desc "Start Puma (socket)"
  task :start_puma_socket do
    on roles :all do
      info "Starting Puma (socket) workers: #{workers}"
      invoke "easy:bundle_exec", "puma -d -w #{workers} -t 32 -e production -b unix:///var/run/shared/easy-lotto.sock --pidfile #{fetch(:server_pid)}"
    end
  end

  desc "Start Puma"
  task :start_puma do
    on roles :all do
      info "Starting Puma (socket) workers: #{workers}"
      invoke "easy:bundle_exec", "puma -d -w #{workers} -t 32 -e production -p 8080 --pidfile #{fetch(:server_pid)}"
    end
  end

  desc "Start Unicorn"
  task :start_unicorn do
    on roles :all do
      info "Starting Unicorn workers: #{workers}"
      invoke "easy:bundle_exec", "unicorn -D -E production -c config/unicorn.rb --listen 0.0.0.0:8080"
    end
  end

  before "easy:start_unicorn", "easy:replace_worker"

  task :replace_worker do
    on roles :all do
      within current_path do
        info "Replacing worker_processes for #{workers} on file `config/unicorn.rb`"
        execute :sed, "-i.bak 's/worker_processes.*/worker_processes #{workers}/g' config/unicorn.rb"
      end
    end
  end

  desc "Stop Rails Server (QUIT)"
  task :stop do
    on roles(:app) do
      within current_path do
        if test("[ -e #{fetch(:server_pid)} ]")
          if test("kill -0 #{pid}")
            info "stopping rails server..."
            execute :kill, "-s QUIT", pid
          else
            info "cleaning up dead server pid..."
            execute :rm, fetch(:server_pid)
          end
        else
          info "server is not running..."
        end
      end
    end
  end

  desc "Show server status"
  task :status do
    on roles(:app) do
      within current_path do
        if test("[ -e #{fetch(:server_pid)} ]")
          execute :ps, "-p", pid
        else
          info "server is not running =( ..."
        end
      end
    end
  end

  desc "Re-start Rails Server (start + stop)"
  task :restart do
    invoke "easy:stop"
    invoke "easy:start"
  end

  desc "NGINX status (CentOS)"
  task :nginx_status_centos do
    on roles(:app) do
      within current_path do
         execute :sudo, "systemctl status nginx"
      end
    end
  end

  desc 'Bundle exec [INTERNAL]'
  task :bundle_exec, :command do | _, args |
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          info "starting server, args [#{args[:command]}]"
          execute :bundle, "exec", args[:command]
        end
      end
    end
  end

end

def server_args
  ENV['SERVER_ARGS']
end

def workers
  ENV['WORKERS'] || 1
end

def pid
  "`cat #{fetch(:server_pid)}`"
end
