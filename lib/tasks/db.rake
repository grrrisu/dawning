namespace 'db' do

  desc 'seed sample data for development'
  task :sample => [:environment, "db:seed"] do
    require File.join(Rails.root, '/db/seeds.rb')
    require File.join(Rails.root, '/db/sample_seeds.rb')
  end

end