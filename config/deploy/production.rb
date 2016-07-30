role :web, 'argon'
role :app, 'argon'
role :db,  'argon', primary: true

set :branch,    "production"
set :deploy_to, "/srv/sites/dawning.zero-x.net"
