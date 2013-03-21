server "xenon", :app, :web, :db, :primary => true
set :branch,  "master"
set :rails_env, "production"

set :deploy_to,   "/m42/sites/dawning"

set :unicorn_pid_file,     "#{shared_path}/pids/unicorn.pid"
set :unicorn_config_file,  "unicorn.rb"
