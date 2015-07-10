require 'mina/bundler'

set :user, 'touchtech'
set :domain, 'max'
set :deploy_to, '/Users/touchtech/workspace/zaffron'
set :repository, 'git@github.com:TouchtechLtd/zaffron.git'
set :branch, 'master'

task :deploy => :environment do
  queue! %[cd "#{deploy_to}"]
  queue! %[echo "Pulling lastest master"]
  queue! %[git pull origin master]
  queue! %[echo "Done!"]
  queue! %[echo "Restarting Zaffron..."]
  queue! %[launchctl unload ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist]
  queue! %[launchctl load ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist]
  queue! %[echo "Restart successful!"]
end
