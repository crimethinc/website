source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

# app server
gem 'rails', '~> 7.2.1'

# database
gem 'pg'

# webserver
gem 'puma'

# assets
gem 'autoprefixer-rails'
gem 'bootstrap'
gem 'sassc-rails'
gem 'sitemap_generator' # for generating a compliant xml sitemap
gem 'uglifier'

# Javascript / Hotwire
gem 'importmap-rails'
gem 'stimulus-rails'

# JSON views
gem 'jbuilder'

# text utilities
gem 'addressable'      # for current URL with a subdomain
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
gem 'lograge'
gem 'logstash-event'

# uploads using Active Storage
gem 'aws-sdk-s3'
gem 'image_processing'

# job queue using Active Job
gem 'sidekiq', '< 8'

# syndication
gem 'down' # downloading images from ActiveStorage/S3

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
  gem 'pry-byebug', platform: :mri
  gem 'rails-controller-testing'
  gem 'rails-erd'
  gem 'rspec-rails', '> 6'
  gem 'selenium-webdriver'

  # codestyle guide and linting
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
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
  gem 'squasher'
  gem 'web-console'

  # For memory profiling
  gem 'memory_profiler'

  # For call-stack profiling flamegraphs
  gem 'fast_stack'
  gem 'flamegraph'
  gem 'stackprof'

  gem 'ruby-lsp'
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
