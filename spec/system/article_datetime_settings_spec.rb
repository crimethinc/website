require 'rails_helper'

describe 'Setting and changing an articles published_at date', :js do
  include ActiveSupport::Testing::TimeHelpers

  before do
    Current.theme = '2017'
  end

  let(:admin) do
    create(:user, username: 'user1', password: 'c' * 31, role: 'publisher')
  end

  it 'creates a new article' do
    login_user(admin)
    visit '/admin/articles'

    click_link_or_button 'NEW'

    within '#publication_datetime' do
      execute_script("document.getElementById('publication_date').value = '2018-12-24';")
      execute_script("document.getElementById('publication_time').value = '11:59:00';")
      select('UTC', from: 'article_published_at_tz')
    end

    within('#publication-status') { find('label[for=publication_status_draft]').click }

    find_button('Save', match: :first).click

    expect(page).to have_content 'Article was successfully created'
    article = Article.first
    expect(article.published_at.utc).to eq('2018-12-24 11:59:00 UTC')
  end

  it 'updates an existing article' do
    article = create(:article, published_at: Time.zone.parse('2018-12-24 11:59:00 UTC'))
    expect(article.published_at.utc).to eq('2018-12-24 11:59:00 UTC')
    expect(article.published_at_tz).to eq('Pacific Time (US & Canada)')

    login_user(admin)
    visit '/admin/articles'

    click_link_or_button 'EDIT'
    within '#publication_datetime' do
      # make sure pre-fills are right
      expect(find_field('published_at_date').value).to eq '2018-12-24'
      expect(find_field('published_at_time').value).to eq '03:59:00'
      expect(find_field('article_published_at_tz').value).to eq 'Pacific Time (US & Canada)'

      execute_script("document.getElementById('publication_date').value = '2018-12-26';")
      execute_script("document.getElementById('publication_time').value = '22:59:00';")
      select('UTC', from: 'article_published_at_tz')
    end

    within('#publication-status') { find('label[for=publication_status_draft]').click }

    find_button('Save', match: :first).click

    expect(page).to have_content 'Article was successfully updated'
    expect(article.reload.published_at.utc).to eq('2018-12-26 22:59:00 UTC')
    expect(article.reload.published_at_tz).to eq('UTC')
  end

  it 'saves an article without entering publication date info' do
    login_user(admin)
    visit '/admin/articles'

    click_link_or_button 'NEW'

    within('#publication-status') { find('label[for=publication_status_draft]').click }

    find_button('Save', match: :first).click

    expect(page).to have_content 'Article was successfully created'
    article = Article.first
    expect(article.published_at).to be_nil
  end

  it 'uses ‘PUBLISH NOW’ feature' do
    freeze_time do
      login_user(admin)
      visit '/admin/articles'

      click_link_or_button 'NEW'

      within('#datetime') { click_link_or_button 'Publish NOW!' }

      expect(page).to have_content 'Article was successfully created'
      article = Article.last

      expect(article.reload.published_at_tz).to eq('UTC')
      expect(article.published_at).to eq(Time.now.utc)
      expect(article).to be_published
    end
  end

  it 'Sets the publication date/time if article is `published` and fields are blank' do
    freeze_time do
      login_user(admin)
      visit '/admin/articles'

      click_link_or_button 'NEW'

      within('#publication-status') { find('label[for=publication_status_published]').click }
      find_button('Save', match: :first).click

      expect(page).to have_content 'Article was successfully created'
      article = Article.last

      expect(article.reload.published_at_tz).to eq('UTC')
      expect(article.published_at).to eq(Time.now.utc + 100.years)
      expect(article).to be_published
    end
  end
end
