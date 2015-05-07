worker_processes 1

listen "/tmp/unicorn.paredao-bbb.com.br.sock", backlog: 64

current = "/home/ubuntu/apps/paredao-bbb/current"

working_directory current
pid "#{current}/tmp/pids/unicorn.pid"
stderr_path "#{current}/log/unicorn.log"
stdout_path "#{current}/log/unicorn.log"

timeout 30
preload_app true

before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(current, 'Gemfile')
end

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end


