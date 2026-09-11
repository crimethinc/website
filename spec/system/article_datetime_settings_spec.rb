require 'rails_helper'

describe 'Setting and changing an articles published_at date', :js do
  include ActiveSupport::Testing::TimeHelpers

  before do
    Current.theme = '2017'
    create(:user, username: 'user1', password: 'c' * 31, role: 'publisher')
  end

  it 'uses ‘PUBLISH NOW’ feature' do
    freeze_time do
      login_user
      visit '/admin/articles'

      click_link_or_button 'NEW'

      within('#datetime') { click_link_or_button 'Publish NOW!' }

      expect(page).to have_text 'Article was successfully created'
      article = Article.last

      expect(article.reload.published_at_tz).to eq('UTC')
      expect(article.published_at).to eq(Time.now.utc)
      expect(article).to be_published
    end
  end
end
