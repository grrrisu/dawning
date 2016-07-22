role :web, '127.0.0.1:2222'
role :app, '127.0.0.1:2222'
role :db,  '127.0.0.1:2222', primary: true

set :branch,    "argon"
set :deploy_to, "/srv/sites/dawning.zero-x.net"

set :rails_env, "production"
set :thin_config_path, "config/thin/production.yml"
