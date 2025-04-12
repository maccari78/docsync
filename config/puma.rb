max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

if ENV['RAILS_ENV'] == 'development'
  ssl_bind '127.0.0.1', '3000', {
    key: 'config/ssl/localhost.key',
    cert: 'config/ssl/localhost.crt',
    verify_mode: 'none'
  }
else
  workers ENV.fetch('WEB_CONCURRENCY') { 2 } 
  preload_app! 
  bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}" 
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord) 
  end
end

plugin :tmp_restart