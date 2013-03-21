# setup rvm
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

# setup bundler
require 'bundler/capistrano'
set :bundle_without, %w(development test)

# setup multistage
set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'

# setup airbrake
require './config/boot'
require 'airbrake/capistrano'

# main details
set :application, "dawning"
set :number_of_workers, 1

# deployment details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :user, "grrrisu"
set :use_sudo, false
#set :rake, "bundle exec rake"
set :deploy_to, "/m42/sites/#{application}"

# repo details
set :scm, :git
set :repository,    "git://github.com/grrrisu/dawning.git"
set :keep_releases, 5

after 'deploy:setup', 'deploy:setup_shared_dirs'
before 'deploy:assets:precompile', 'deploy:symlink_configs'
#after "deploy:create_symlink",  "deploy:migrate"
#before 'deploy:migrate', 'deploy:create_db'
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :start do
    top.unicorn.start
  end

  task :stop do
    top.unicorn.stop
  end

  task :restart do
    unicorn.restart
  end

  desc "setup additional shared directories "
  task :setup_shared_dirs do
    dirs = ["#{shared_path}/config"]
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  task :create_db, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    migrate_env = fetch(:migrate_env, "")

    run "cd #{release_path} && #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:create"
  end

  task :symlink_configs do
    %w{mongoid.yml app_config.yml newrelic.yml}.each do |yml_file|
      run "ln -s #{shared_path}/config/#{yml_file} #{release_path}/config/#{yml_file}"
    end
  end
end

namespace :unicorn do
  set :unicorn_pid do
    "#{shared_path}/pids/unicorn.pid"
  end

  # starts unicorn on deploy:cold in release path as current path doesn't yet exist
  desc "start unicorn"
  task :start, :roles => :app do
    run "if [[ -d #{current_path} ]]; then cd #{current_path} && bundle exec unicorn_rails --daemonize --config-file #{current_path}/config/#{unicorn_config_file} --env #{rails_env}; else cd #{release_path} && bundle exec unicorn_rails --daemonize --config-file #{release_path}/config/#{unicorn_config_file} --env #{rails_env}; fi"
  end

  desc "stop unicorn"
  task :stop, :roles => :app do
    puts "Gracefully terminating unicorn master..."
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "restart unicorn"
  task :restart, :roles => :app do
    puts "Gracefully restarting master and workers without service interruption..."
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
end
