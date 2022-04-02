require 'simplecov'
SimpleCov.start 'rails'

def login_user _user
  visit '/signin'

  within('main') do
    fill_in 'username', with: 'user1'
    fill_in 'password', with: 'c' * 31
  end

  click_button 'Sign In'
  expect(page).to have_content 'Logged in!'
end
