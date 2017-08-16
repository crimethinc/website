require 'rails_helper'

feature "Setting and changing an articles published_at date" do
  let(:admin) do
    create(:user, username: 'user1', email: 'user@example.com', password: 'c'*31)
  end

  background do
    create(:status, :published)
    create(:status, :draft)
  end

  scenario "Creating a new article" do
    login_user(admin)

    click_on 'NEW'

    within '#publication_datetime' do
      select('2018', from: 'article_published_at_1i')
      select('12 - December', from: 'article_published_at_2i')
      select('24', from: 'article_published_at_3i')
      select('11', from: 'article_published_at_4i')
      select('59', from: 'article_published_at_5i')
    end

    within('#publication_status') { choose 'Draft' }

    find_button('Save', match: :first).click

    article = Article.first
    expect(article.published_at.utc).to eq('2018-12-24 11:59:00 UTC')
    expect(article.published_at.utc).to eq('2018-12-24 11:59:00 UTC')
  end

  scenario "updating an existing article" do
    article = create(:article, published_at: Time.parse('2018-12-24 11:59:00 UTC'))
    expect(article.published_at.utc).to eq('2018-12-24 11:59:00 UTC')

    login_user(admin)

    click_on 'EDIT'
    within '#publication_datetime' do
      select('2018', from: 'article_published_at_1i')
      select('12 - December', from: 'article_published_at_2i')
      select('26', from: 'article_published_at_3i')
      select('22', from: 'article_published_at_4i')
      select('59', from: 'article_published_at_5i')
    end

    within('#publication_status') { choose 'Draft' }

    find_button('Save', match: :first).click

    expect(article.reload.published_at.utc).to eq('2018-12-26 22:59:00 UTC')
  end

  scenario "Using 'PUBLISH NOW' feature", :js do
    # TODO: the 'publish now' feature relies on a JavaScript in
    # the front-end to automatically set the form fields and submit the
    # form. This makes testing time hard since we cannot
    # Timecop.freeze the front-end. Consider making the 'Publish Now!'
    # feature a back-end feature
    login_user(admin)

    click_on 'NEW'

    time = Time.now.utc

    within('#datetime') { click_on 'Publish NOW!' }

    expect(page).to have_content 'Article was successfully created'
    article = Article.last

    # rough approximation of 'now'
    expect(article.published_at.day).to eq(time.day)
    expect(article.published_at.month).to eq(time.month)
    expect(article.published_at.year).to eq(time.year)
    expect(article.published_at.min).to eq(time.min)
    expect(article.published_at.hour).to eq(time.hour)
    expect(article).to be_published
  end
end
