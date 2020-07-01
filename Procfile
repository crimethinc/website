release: bundle exec rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: RAILS_MAX_THREADS=${SIDEKIQ_RAILS_MAX_THREADS:-25} bundle exec sidekiq -q default -q mailers
