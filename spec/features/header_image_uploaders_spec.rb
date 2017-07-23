require 'rails_helper'

feature "Adding an article header image" do
  background do
    create(:user, username: 'user', email: 'user@example.com', password: 'c'*31)
    create(:status, name: 'draft')
    create(:status, name: 'published')
  end

  scenario "Adding a header to a new article" do
    sign_in_as_admin
    click_on 'NEW'

    # should not see the header image upload form until a publication
    # date is set
    expect(page).not_to have_selector('#article-header-image-row')

    find_button('Save', match: :first).click

    click_on 'EDIT'

    # now that there is a publication date, should see the image uploader
    within('#appearance') do
      expect(page).to have_selector('#article-header-image-row')
    end
  end

  scenario "" do
  end

  def sign_in_as_admin
    visit '/signin'
    within('main') do
      fill_in 'username', with: 'user'
      fill_in 'password', with: 'c'*31
    end
    click_button 'Sign In'
    expect(page).to have_content 'Logged in!'
  end
end
