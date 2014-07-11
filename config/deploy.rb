# setup rvm
require 'rvm/capistrano'
set :rvm_ruby_string, '2.0.0'
set :rvm_type, :system

# setup bundler
require 'bundler/capistrano'
set :bundle_without, %w(development test)

# setup multistage
set :stages, %w(production helium)
set :default_stage, "production"
require 'capistrano/ext/multistage'

# setup airbrake
require './config/boot'
require 'airbrake/capistrano'

# main details
set :application, "dawning"
#set :number_of_workers, 1

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
before 'deploy:symlink_configs', 'upload_configs'
#after "deploy:create_symlink",  "deploy:migrate"
#after 'deploy:symlink_configs', 'deploy:create_db'
after "deploy", "deploy:cleanup"

task :upload_configs do
  {'mongoid_production.yml' => 'mongoid.yml',
   'app_config_production.yml' => 'app_config.yml',
   'newrelic.yml' => 'newrelic.yml',
   'thin_production.yml' => 'thin.yml'}.each do |local_file, remote_file|
    upload File.expand_path("../#{local_file}", __FILE__), "#{shared_path}/config/#{remote_file}", via: :scp
  end
end

namespace :deploy do

  # Thin

  desc "Start the Thin processes"
  task :start do
    sudo "cd #{current_path} && bundle exec thin start -C config/thin.yml"
  end

  desc "Stop the Thin processes"
  task :stop do
    sudo "cd #{current_path} && bundle exec thin stop -C config/thin.yml"
  end

  desc "Restart the Thin processes"
  task :restart do
    sudo "cd #{current_path} && bundle exec thin restart -C config/thin.yml"
  end


  desc "setup additional shared directories "
  task :setup_shared_dirs do
    dirs = ["#{shared_path}/config"]
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  task :create_db, roles: :db, only: { primary: true } do
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
