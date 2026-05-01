module LoginHelper
  def login_user
    visit '/signin'

    within('main') do
      fill_in 'username', with: 'user1'
      fill_in 'password', with: 'c' * 31
    end

    click_link_or_button 'Sign In'
    expect(page).to have_text 'Logged in!'
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :system
end
