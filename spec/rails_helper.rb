ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'

require 'support/factory_bot'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# set up headless chrome webdriver for feature specs
chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil) # This is from the heroku bin defined in app.json
chrome_opts = if chrome_bin
                # CI is running on heroku
                { chromeOptions: { 'binary' => chrome_bin } }
              else
                # CI is running locally or in Travis
                { chromeOptions: { args: %w[headless disable-gpu] } }
              end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(chrome_opts)
  )
end
Capybara.javascript_driver = :headless_chrome
