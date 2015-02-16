role :web, 'neon'
role :app, 'neon'
role :db,  'neon', primary: true

set :branch,    "production"
set :deploy_to, "/srv/sites/dawning.zero-x.net"