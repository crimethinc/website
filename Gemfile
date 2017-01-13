source "https://rubygems.org"
ruby "2.4.0"

# app server
gem "rails", "~> 5.0.1"

# database
gem "pg"

# webserver
gem "puma"
gem "foreman"

# assets
gem "bootstrap-sass", "3.3.7"
gem "sass-rails"
gem "autoprefixer-rails"
gem "uglifier"
gem "jquery-rails"

# text utilities
gem "rubypants" # for smart quotes
gem "sterile"   # for slugs
gem "kramdown"  # for Markdown processing
gem "stringex"  # for Markdown header IDs processing

# auth
gem "bcrypt", "~> 3.1.7"

# pagination
gem "kaminari"

# dev and testing
group :development, :test do
  gem "byebug", platform: :mri
  gem "nokogiri"
end

# dev
group :development do
  gem "web-console"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# monitoring
gem "newrelic_rpm"
gem "new_relic_ping"
gem "bugsnag"

# windows dev
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
