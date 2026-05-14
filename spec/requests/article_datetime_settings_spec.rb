require 'rails_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'admin article controller set_published_at before_action' do
  # rubocop:enable RSpec/DescribeClass
  let(:user) { create(:user, username: 'user1', password: 'c' * 31) }
  let(:publisher) { create(:user, username: 'publisher1', password: 'c' * 31, role: 'publisher') }

  describe 'when creating an article' do
    it 'compute the published_at attribute properly' do
      post sessions_url, params: { username: user.username, password: user.password }

      article_attrs = attributes_for(:article, publication_status: :draft)
      article_attrs.delete(:published_at)
      article_attrs[:published_at_tz] = 'UTC'
      post admin_articles_url, params: {
        article:           article_attrs,
        button:            '',
        published_at_date: '2018-12-24',
        published_at_time: '11:59:00',
        controller:        'admin/articles',
        action:            'create'
      }

      expect(Article.last.published_at).to eq('2018-12-24 11:59:00 UTC')
    end
  end

  describe 'when updating an existing article' do
    it 'compute the published_at attribute properly' do
      post sessions_url, params: { username: user.username, password: user.password }

      article_attrs = attributes_for(:article)
      article_attrs[:published_at] = DateTime.parse('2018-12-25T03:59:00Z')
      post admin_articles_url, params: {
        article:    article_attrs,
        button:     '',
        controller: 'admin/articles',
        action:     'create'
      }

      put admin_article_url(Article.last.id), params: { article: { published_at_tz: 'UTC' },
                                                        published_at_time: '11:59:00', published_at_date: '2018-12-24' }

      expect(Article.last.published_at).to eq('2018-12-24 11:59:00 UTC')
    end
  end

  describe 'when creating a draft article without publication date info' do
    it 'sets published_at to nil' do
      post sessions_url, params: { username: user.username, password: user.password }

      article_attrs = attributes_for(:article, publication_status: :draft)
      article_attrs.delete(:published_at)
      post admin_articles_url, params: {
        article:    article_attrs,
        button:     '',
        controller: 'admin/articles',
        action:     'create'
      }

      expect(Article.last.published_at).to be_nil
    end
  end

  describe 'when creating a published article without publication date info' do
    it "compute the published_at in 100 years to avoid unwanted publication if you're a publisher" do
      post sessions_url, params: { username: publisher.username, password: publisher.password }

      article_attrs = attributes_for(:article)
      article_attrs.delete(:published_at)
      post admin_articles_url, params: {
        article:           article_attrs,
        button:            '',
        published_at_date: '2018-12-24',
        published_at_time: '11:59:00',
        controller:        'admin/articles',
        action:            'create'
      }

      expect(Article.last.published_at.to_s).to eq((Time.now.utc + 100.years).to_s)
    end

    # FIXME: is this a bug? Should we catch this in the controller, and refuse
    # to set publication_status to `publishe` when it's someone who hasn't the
    # `publisher` role and set a flash notice to they know the article wasn't
    # published.
    it "compute set published_at to nil if you're not a publisher" do
      post sessions_url, params: { username: user.username, password: user.password }

      article_attrs = attributes_for(:article)
      article_attrs.delete(:published_at)
      post admin_articles_url, params: {
        article:           article_attrs,
        button:            '',
        published_at_date: '2018-12-24',
        published_at_time: '11:59:00',
        controller:        'admin/articles',
        action:            'create'
      }

      expect(Article.last.published_at).to be_nil
    end
  end
end
