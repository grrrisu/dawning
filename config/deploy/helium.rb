role :web, '127.0.0.1'
role :app, '127.0.0.1'
role :db,  '127.0.0.1', primary: true

# set :port, 2222
set :branch,    "master"
set :deploy_to, "/srv/sites/dawning.zero-x.net"