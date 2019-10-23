source 'https://rubygems.org'
ruby '~> 2.6.3'

# app server
gem 'rails', '~> 6.0.0'

# database
gem 'pg'
gem 'scenic', '~> 1.5', '>= 1.5.1'

# webserver
gem 'puma'

# assets
gem 'autoprefixer-rails'
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'      , '>= 4.3.5' # for bootstrap pages (admin, steal-something-from-work-day)
gem 'jquery-ui-rails'   , '>= 6.0.1' # for polyfilling forms in admin/articles
gem 'sassc-rails', '>= 2.1.2'
gem 'sitemap_generator' # for generating a compliant xml sitemap
gem 'uglifier'

# JSON views
gem 'jbuilder', '~> 2.9'

# text utilities
gem 'kramdown'       # for Markdown processing
gem 'markdown_media' # for [[ media embeds ]]
gem 'rubypants'      # for smart quotes
gem 'sterile'        # for slugs
gem 'stringex'       # for Markdown header IDs processing

# auth
gem 'bcrypt', '~> 3.1.13'

# pagination
gem 'kaminari', '>= 1.1.1'

# memcache
gem 'dalli'

# codestyle guide and linting
gem 'rubocop', require: false
gem 'rubocop-performance'
gem 'rubocop-rspec'

# Stripe for /support
gem 'stripe'

# observability
gem 'lograge', '>= 0.11.2'
gem 'logstash-event'

# dev and testing
group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'dotenv-rails', '>= 2.7.5'
  gem 'factory_bot_rails', '>= 5.1.1'
  gem 'i18n-debug'
  gem 'launchy'
  gem 'nokogiri'
  gem 'overcommit'
  gem 'rails-controller-testing', '>= 1.0.4'
  gem 'rspec-rails', '~> 4.0.0.beta3'
  gem 'selenium-webdriver'
  gem 'spring-commands-rspec'
  gem 'webdrivers'
end

# testing / ci
group :test do
  gem 'simplecov', require: false
end

# dev
group :development do
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.2.0'
  gem 'referral', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 4.0.1'

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
