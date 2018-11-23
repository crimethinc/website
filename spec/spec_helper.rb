RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :chrome
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = 'tmp/rspec-failures.txt'
end

def login_user(_user)
  visit '/signin'
  within('main') do
    fill_in 'username', with: 'user1'
    fill_in 'password', with: 'c' * 31
  end
  click_button 'Sign In'
  expect(page).to have_content 'Logged in!'
end
