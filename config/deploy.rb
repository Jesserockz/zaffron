require 'mina/bundler'

set :user, 'pi'
set :domain, 'wumppi'
set :deploy_to, '/opt/zaffron'
set :repository, 'git@github.com:TouchtechLtd/zaffron.git'
set :branch, 'master'

task :deploy => :environment do
  queue! %[cd "#{deploy_to}"]
  queue! %[echo "Pulling lastest master"]
  queue! %[git pull origin master]
  queue! %[echo "Done!"]
  queue! %[echo "Restarting Zaffron..."]
  queue! %[sudo service zaffron restart]
  queue! %[echo "restart successfully!"]
end
