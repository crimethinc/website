require 'rails_helper'

feature "Signing in as an admin" do
  background do
    create(:user, username: 'user1', password: 'c'*31)
  end

  scenario "Signing in with correct credentials"  do
    visit '/signin'
    within('main') do
      fill_in 'username', with: 'user1'
      fill_in 'password', with: 'c'*31
    end
    click_button 'Sign In'

    expect(page).to have_content 'Logged in!'
    expect(current_path).to eq(admin_articles_path)
  end

  given(:other_user) { create(:user, username: 'user2', password: 'Na'*30) }

  scenario "Signing in with invalid password" do
    visit '/signin'
    within('main') do
      fill_in 'username', with: 'user2'
      fill_in 'password', with: 'Ba'*30
    end
    click_button 'Sign In'

    # TODO: is it weird that we don't go back to /signin and there is
    # no error message?
    expect(current_path).to eq(auth_sessions_path)
  end
end
