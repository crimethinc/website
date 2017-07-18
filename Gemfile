source "https://rubygems.org"
ruby "~> 2.4.1"

# app server
gem "rails", "~> 5.1.1"

# database
gem "pg"
gem "scenic", "~> 1.4"

# webserver
gem "puma"

# assets
gem "bootstrap-sass", "3.3.7"
gem "sass-rails"
gem "autoprefixer-rails"
gem "uglifier"
gem "jquery-rails"
gem "sitemap_generator" # generates compliant xml sitemap

# text utilities
gem "rubypants"      # for smart quotes
gem "sterile"        # for slugs
gem "kramdown"       # for Markdown processing
gem "stringex"       # for Markdown header IDs processing
gem "markdown_media" # for [[ media embeds ]]

# auth
gem "bcrypt", "~> 3.1.7"

# forms
gem "cocoon", "~> 1.2.9"

# pagination
gem "kaminari"

# memcache
gem "dalli"

# dev and testing
group :development, :test do
  gem "byebug", platform: :mri
  gem "nokogiri"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "guard-rspec"
  gem "spring-commands-rspec"
  gem "simplecov", :require => false
  gem "factory_girl_rails"
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'launchy'
end

# dev
group :development do
  gem "web-console"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  # For measuring page/code performance
  gem "rack-mini-profiler"

  # For memory profiling
  gem "memory_profiler"

  # For call-stack profiling flamegraphs
  gem "flamegraph"
  gem "stackprof"
  gem "fast_stack"
end

# monitoring
gem "newrelic_rpm"
gem "new_relic_ping"
gem "bugsnag"

# DDOS protection
gem "rack-attack"
gem "redis"

# windows dev
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
