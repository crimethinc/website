source 'https://rubygems.org'
ruby '~> 2.5.3'

# app server
gem 'rails', '~> 5.2.1'

# database
gem 'pg'
gem 'scenic', '~> 1.4'

# webserver
gem 'puma'
gem 'rack-timeout'

# assets
gem 'autoprefixer-rails'
gem 'bootstrap', '~> 4.1.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'   # used for polyfilling forms in admin/articles
gem 'sassc-rails'
gem 'sitemap_generator' # generates compliant xml sitemap
gem 'uglifier'

# text utilities
gem 'kramdown'       # for Markdown processing
gem 'markdown_media' # for [[ media embeds ]]
gem 'rubypants'      # for smart quotes
gem 'sterile'        # for slugs
gem 'stringex'       # for Markdown header IDs processing

# auth
gem 'bcrypt', '~> 3.1.12'

# pagination
gem 'kaminari'

# memcache
gem 'dalli'

# codestyle guide and linting
gem 'rubocop', require: false
gem 'rubocop-rspec'

# Stripe for /support
gem 'stripe'

# observability
gem 'lograge'
gem 'logstash-event'

# dev and testing
group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'nokogiri'
  gem 'overcommit'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'spring-commands-rspec'
end

# dev
group :development do
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
