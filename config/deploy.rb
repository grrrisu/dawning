set :application, 'dawning'
set :repo_url, 'git@github.com:grrrisu/dawning.git'

set :log_level, :info

set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'

set :linked_files, %w{config/mongoid.yml config/secrets.yml config/level.yml config/thin/production.yml}
set :linked_dirs, %w{log tmp/pids tmp/sockets public/system public/assets}

set :ssh_options, {
  user: "grrrisu",
  forward_agent: true
}

before 'deploy:check:linked_files', 'deploy:upload_config_files'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do

  desc "upload config files"
  task :upload_config_files do
    on roles(:all) do |host|
      {'mongoid_production.yml' => 'mongoid.yml',
       'secrets.yml' => 'secrets.yml',
       'thin/production.yml' => 'thin/production.yml',
       'level.yml' => 'level.yml'
       }.each do |local_file, remote_file|
        upload! File.expand_path("../#{local_file}", __FILE__), "#{shared_path}/config/#{remote_file}"
        info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
