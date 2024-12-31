release: bundle exec rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: RAILS_MAX_THREADS=${SIDEKIQ_RAILS_MAX_THREADS} bundle exec sidekiq -q default -q mailers -q active_storage_analysis -q active_storage_purge
