set :application, 'dawning'
set :repo_url, 'git@github.com:grrrisu/dawning.git'

set :rvm_ruby_version, File.read(".ruby-version").strip

set :log_level, :info

set :linked_files, %w{config/mongoid.yml config/secrets.yml config/level.yml config/thin/production.yml}
set :linked_dirs, %w{log tmp/pids tmp/sockets public/system public/assets}

set :ssh_options, {
  user: "grrrisu",
  forward_agent: true
}

after 'deploy:publishing', 'deploy:restart'

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
