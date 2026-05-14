require 'rails_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'admin article controller set_published_at before_action set published_at' do
  include ActiveSupport::Testing::TimeHelpers

  let(:draft_attrs) { attributes_for(:article, :draft, published_at_tz: 'UTC', published_at: nil).compact }
  let(:published_attrs) { attributes_for(:article, publication_at_tz: 'UTC', published_at: nil).compact }
  let(:request_params) { { button: '', controller: 'admin/articles' } }

  shared_examples 'handles the publication date' do |user_role|
    subject(:actual_published_at) { Article.last.published_at.to_s }

    let(:user) { create(:user, password: 'c' * 31, role: user_role) }
    let(:now) { Time.now.utc }

    before do
      post sessions_url, params: { username: user.username, password: user.password }
    end

    context "when creating an article record with role: #{user_role}" do
      before do
        travel_to(now) do
          post admin_articles_url, params: { article: article_attrs, action: 'create', **request_params }
        end
      end

      it { is_expected.to eq expected_published_at }
    end

    context "when updating an existing article record with role: #{user_role}" do
      before do
        travel_to(now) do
          put admin_article_url(existing_article.id),
              params: { article: article_attrs, action: 'update', **request_params }
        end
      end

      it { is_expected.to eq expected_published_at }
    end
  end

  context 'with valid publication info' do
    let(:request_params) { super().merge(published_at_date: '2018-12-24', published_at_time: '11:59:00') }
    let(:article_attrs) { draft_attrs.merge(published_at: DateTime.parse('2018-12-25T03:59:00Z')) }
    let(:existing_article) { create(:article, :draft, published_at: DateTime.parse('2018-12-25T03:59:00Z')) }

    it_behaves_like 'handles the publication date', :author do
      let(:expected_published_at) { '2018-12-24 11:59:00 UTC' }
    end
  end

  context 'when the publication info is missing' do
    let(:request_params) { super().merge(published_at_date: nil, published_at_time: nil) }

    describe 'when the article is marked as published' do
      let(:existing_article) { create(:article) }
      let(:article_attrs) { published_attrs.merge(published_at: nil) }

      it_behaves_like 'handles the publication date', :publisher do
        let(:expected_published_at) { (now.utc + 100.years).to_s }
      end

      it_behaves_like 'handles the publication date', :author do
        let(:expected_published_at) { '' }
      end
    end

    describe 'when the article is still a draft' do
      let(:existing_article) { create(:article, :draft) }
      let(:article_attrs) { draft_attrs.merge(published_at: nil) }

      it_behaves_like 'handles the publication date', :publisher do
        let(:expected_published_at) { '' }
      end

      it_behaves_like 'handles the publication date', :author do
        let(:expected_published_at) { '' }
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
