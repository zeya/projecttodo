require "bundler/capistrano"

#default_environment['PATH'] = '/home/superuser/.rbenv/versions/1.9.3-p286/bin:$PATH'
#default_environment['GEM_PATH']= '/home/superuser/.rbenv/versions/1.9.3-p286/lib/ruby/gems/1.9.1'

#change this ip address to correct server address
server "192.168.1.2", :web, :app, :db, primary: true

set :application, "projecttodo"
set :user, "superuser"
set :deploy_to, "/home/#{user}/apps/#{application}"
#set :deploy_via, :remote_cache
set :deploy_via, :copy
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:zeya/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
#ssh_options[:keys] = "~/.ssh/id_rsa.pub"
#ssh_options[:forward_agent] = true
set :ssh_options, {:forward_agent => true}

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} nginx/unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "sudo service nginx #{command}"
      run "sudo /etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  #desc "Make sure local git is in sync with remote."
  #task :check_revision, roles: :web do
  #  unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #    puts "WARNING: HEAD is not the same as origin/master"
  #    puts "Run `git push` to sync changes."
  #    exit
  #  end
  #end
  #before "deploy", "deploy:check_revision"
end
