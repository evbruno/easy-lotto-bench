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

  set :server_pid, -> { File.join(current_path, "tmp", "pids", "server.pid") }

  # https://github.com/tablexi/capistrano3-unicorn/blob/master/lib/capistrano3/tasks/unicorn.rake

  desc 'Start Rails Server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          info "starting rails server..."
          execute :bundle, "exec rails", "server", "-d -p 8080 -e production -b 0.0.0.0"
        end
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

  desc "Re-start Rails Server (start + stop)"
  task :restart do
    invoke "easy:stop"
    invoke "easy:start"
  end

end


def pid
  "`cat #{fetch(:server_pid)}`"
end
