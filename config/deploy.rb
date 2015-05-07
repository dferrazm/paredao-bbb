# config valid only for Capistrano 3.1
lock '3.2.1'

# setup repo details
set :application, 'paredao-bbb'
set :deploy_user, 'user'
set :scm, :git
set :repo_url, 'git@github.com:dferrazm/paredao-bbb.git'
set :rvm_type, :user
set :rvm_ruby_version, '2.0.0-p353@paredao-bbb'
set :deploy_to, "/home/user/apps/#{fetch(:application)}"

set :linked_files, %w{config/database.yml config/local_env.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}
set :keep_releases, 3
set :sidekiq_queue, %w(recorder)

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    invoke 'clockwork:restart'

    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
