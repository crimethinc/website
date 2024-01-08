require 'rails_helper'

describe 'Creating sub articles for a live blog' do
  include ActiveSupport::Testing::TimeHelpers

  before do
    Current.theme = '2017'
  end

  let(:admin) do
    create(:user, username: 'user1', password: 'c' * 31, role: 'publisher')
  end
  let(:blog_update_title) { 'live blog update 1' }

  it 'can add sub articles to an existing article' do
    article = create(:article, published_at: Time.zone.parse('2018-12-24 11:59:00 UTC'))

    login_user(admin)
    visit '/admin/articles'

    click_link_or_button article.title
    click_link_or_button 'NEW Nested Article'

    fill_in 'article_title', with: blog_update_title
    within('#datetime') { click_link_or_button 'Publish NOW!' }

    expect(page).to have_content "Part of the #{article.name} Collection"

    click_link_or_button article.title, match: :first
    within('#collection') do
      expect(page).to have_content blog_update_title
    end
  end
end
