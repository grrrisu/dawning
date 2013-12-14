server "neon", :app, :web, :db, primary: true
set :branch,  "master"
set :rails_env, "production"

set :deploy_to,   "/srv/sites/dawning.zero-x.net"
