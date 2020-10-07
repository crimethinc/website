source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

# app server
gem 'rails'

# database
gem 'pg'
gem 'scenic'

# webserver
gem 'puma'

# assets
gem 'autoprefixer-rails'
gem 'bootstrap'
gem 'jquery-rails'      # for bootstrap pages (admin, steal-something-from-work-day)
gem 'jquery-ui-rails'   # for polyfilling forms in admin/articles
gem 'sassc-rails'
gem 'sitemap_generator' # for generating a compliant xml sitemap
gem 'uglifier'

# JSON views
gem 'jbuilder'

# text utilities
gem 'kramdown'         # for Markdown processing
gem 'markdown_media'   # for [[ media embeds ]]
gem 'pandoc-ruby'      # for Word to HTML conversion
gem 'reverse_markdown' # for HTML to Markdown conversion
gem 'rubypants'        # for smart quotes
gem 'sterile'          # for slugs
gem 'stringex'         # for Markdown header IDs processing

# auth
gem 'bcrypt'

# pagination
gem 'kaminari'

# memcache
gem 'dalli'

# Stripe for /support
gem 'stripe'

# observability
gem 'honeycomb-beeline'
gem 'lograge'
gem 'logstash-event'

# uploads using Active Storage
gem 'aws-sdk-s3'
gem 'azure-storage',        require: false
gem 'google-cloud-storage', require: false

gem 'image_processing'

# job queue using Active Job
gem 'sidekiq'

# dev and testing
group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'fasterer', require: false
  gem 'http'
  gem 'i18n-debug'
  gem 'launchy'
  gem 'nokogiri'
  gem 'overcommit'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'spring-commands-rspec'
  gem 'webdrivers'

  # codestyle guide and linting
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end

# testing / ci
group :test do
  gem 'simplecov', require: false
end

# dev
group :development do
  gem 'guard-rspec', require: false
  gem 'listen'
  gem 'referral', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'squasher'
  gem 'web-console'

  # For memory profiling
  gem 'memory_profiler'

  # For call-stack profiling flamegraphs
  gem 'fast_stack'
  gem 'flamegraph'
  gem 'stackprof'
end

# monitoring
gem 'bugsnag'

# DDOS protection
gem 'rack-attack'
gem 'redis'
gem 'redis-store'

# windows dev
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# i18n
gem 'rack-contrib'

group :production do
  # webserver
  gem 'rack-timeout'
end
