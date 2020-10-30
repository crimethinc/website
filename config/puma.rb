workers ENV.fetch('WEB_CONCURRENCY')              { 2 }
max_threads_count = ENV.fetch('RAILS_MAX_THREAD') { 5 }
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

port        ENV.fetch('PORT') { 3000 }
environment ENV.fetch('RAILS_ENV') { 'development' }

# Puma 5 experiment
# https://github.com/puma/puma/issues/2258
wait_for_less_busy_worker
fork_worker
nakayoshi_fork

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
