namespace :clockwork do
  desc "Stop clockwork"
  task :stop do
  	on roles(:app) do
    	execute "if [ -d #{current_path} ] && [ -f #{pid_file} ]; then cd #{current_path} && kill -INT `cat #{pid_file}` ; fi"
  	end
  end

  desc "Start clockwork"
  task :start do
  	on roles(:app) do
    	execute "daemon --inherit --name=clockwork --env='#{rails_env}' --output=#{log_file} --pidfile=#{pid_file} -D #{current_path} -- bundle exec clockwork clock.rb"
  	end
  end

  desc "Restart clockwork"
  task :restart do
  	on roles(:app) do
  		#invoke 'clockwork:stop'
  		invoke 'clockwork:start'
  	end
  end

  def rails_env
    fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
  end

  def log_file
    fetch(:clockwork_log_file, "#{current_path}/log/clockwork.log")
  end

  def pid_file
    fetch(:clockwork_pid_file, "#{current_path}/tmp/pids/clockwork.pid")
  end
end

# namespace :clockwork do
#   desc "Stop clockwork"
#   task :stop do
#     on roles(:app) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :clockworkd, "-c clock.rb  --pid-dir=#{cw_pid_dir} --log-dir=#{cw_log_dir} stop"
#         end
#       end
#     end
#   end

#   desc "Clockwork status"
#   task :status do
#     on roles(:app) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :clockworkd, "-c clock.rb  --pid-dir=#{cw_pid_dir} --log-dir=#{cw_log_dir} status"
#         end
#       end
#     end
#   end

#   desc "Start clockwork"
#   task :start do
#     on roles(:app) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :clockworkd, "-c clock.rb  --pid-dir=#{cw_pid_dir} --log-dir=#{cw_log_dir} start"
#         end
#       end
#     end
#   end

#   desc "Restart clockwork"
#   task :restart do
#     on roles(:app) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           invoke 'clockwork:stop'
#           invoke 'clockwork:start'
#           #execute :bundle, :exec, :clockworkd, "clock.rb  --pid-dir=#{cw_pid_dir} --log-dir=#{cw_log_dir} restart"
#         end
#       end
#     end
#   end

#   def cw_log_dir
#     "#{current_path}/log"
#   end
#   def cw_pid_dir
#     "#{current_path}/tmp/pids"
#   end

#   def rails_env
#     fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
#   end
# end

# namespace :delayed_job do
#   def args
#     fetch(:delayed_job_args, "") #Useful for queuing on specific servers
#   end

#   def delayed_job_roles
#     fetch(:delayed_job_server_role, :app)
#   end

#   desc 'Stop the delayed_job process'
#   task :stop do
#     on roles(delayed_job_roles) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :'script/delayed_job', :stop
#         end
#       end
#     end
#   end

#   desc 'Start the delayed_job process'
#   task :start do
#     on roles(delayed_job_roles) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :'script/delayed_job', args, :start
#         end
#       end
#     end
#   end

#   desc 'Restart the delayed_job process'
#   task :restart do
#     on roles(delayed_job_roles) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, :exec, :'script/delayed_job', args, :restart
#         end
#       end
#     end
#   end

#end
