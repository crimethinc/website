require 'rails_helper'

feature "Checking known burned passwords" do
  background do
    create(:user, username: 'user1', password: 'c'*31)

    # sha1 of '1'*32
    create(:burned_password, password_sha1: 'c66ebd709ec9ee11911ba2718c65a416e194fcc8')
  end

  scenario "When creating a new user" do
    # sign in as current user
    visit '/signin'
    within('main') do
      fill_in 'username', with: 'user1'
      fill_in 'password', with: 'c'*31
    end
    click_button 'Sign In'
    expect(page).to have_content 'Logged in!'

    # proceed to sign up a new user
    visit '/admin/users/new'
    expect(current_path).to eq(new_admin_user_path)

    within('main') do
      fill_in 'Username', with: 'user2'
      fill_in 'Password', with: '1'*32
      fill_in 'Password confirmation', with: '1'*32
    end
    click_button 'Sign Up'

    # be blocked from signing up a user with a known leaked password
    expect(current_path).to eq(admin_users_path)
    within('.alert-danger') do
      expect(page).to have_content "This password has previously appeared" \
                                   " in a data breach. Please choose a " \
                                   "more secure alternative."
    end
  end
end
