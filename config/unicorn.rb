# name of application
application = "dawning"

# environment specific stuff
case ENV["RAILS_ENV"]
when "production"
  worker_processes 1
else
  worker_processes 1
end
listen 7550

# set directories
base_dir = "/m42/sites/dawning/current"
shared_path = "/m42/sites/dawning/shared"
working_directory base_dir

# maximum runtime of requests
timeout 60

# multiple listen directives are allowed
listen "#{shared_path}/unicorn.sock", :backlog => 64

# location of pid file
pid "#{shared_path}/pids/unicorn.pid"

# location of log files
stdout_path "#{shared_path}/log/unicorn.log"
stderr_path "#{shared_path}/log/unicorn.err"

before_exec do |server|
  # see http://unicorn.bogomips.org/Sandbox.html
  ENV["BUNDLE_GEMFILE"] = "#{base_dir}/Gemfile"
end

before_fork do |server, worker|
  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade. The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
