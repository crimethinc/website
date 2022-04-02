Capybara.register_driver :selenium_firefox_in_container do |app|
  opts = Selenium::WebDriver::Firefox::Options.new

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://selenium_firefox:4444/wd/hub",
    capabilities: opts
  )
end

Capybara.register_driver :headless_selenium_firefox_in_container do |app|
  opts = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://selenium_firefox:4444/wd/hub",
    capabilities: opts
  )
end
