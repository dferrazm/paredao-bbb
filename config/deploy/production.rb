#load 'config/recipes/unicorn.rb'

set :ip, 'TODO'
role :app, fetch(:ip)
role :web, fetch(:ip)
role :db,  fetch(:ip)


server fetch(:ip), user: 'user', roles: %w{web app db}

set :rails_env, 'production'

set :stage, :production
set :branch, "master"

set :ssh_options, {
  user: "user",
  keys: ["path-to-key.pem"],
  forward_agent: true,
}
