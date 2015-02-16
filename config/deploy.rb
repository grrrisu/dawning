set :application, 'dawning'
set :repo_url, 'git@github.com:grrrisu/dawning.git'

# Default value for :log_level is :debug
# set :log_level, :debug

set :linked_files, %w{config/mongoid.yml config/secrets.yml config/level.yml}
set :linked_dirs, %w{log tmp/pids tmp/sockets public/system public/assets}

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :ssh_options, {
  user: "grrrisu",
  forward_agent: true,
}

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
