server "127.0.0.1", :app, :web, :db, :primary => true
set :port, 2222
set :branch,  "master"
set :rails_env, "production"

set :deploy_to,   "/srv/sites/dawning.zero-x.net"

set :puma_config_file, "puma.rb"
