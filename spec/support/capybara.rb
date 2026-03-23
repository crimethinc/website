require 'capybara/rspec'
require 'capybara/cuprite'

Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if self.class.metadata[:js]
      driven_by :cuprite
    else
      driven_by :rack_test
    end
  end
end
