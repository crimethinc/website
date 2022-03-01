require 'rails_helper'

describe Article do
  describe 'validations' do
    # TEMP TODO re-enable when tweet character count is smarter
    # it 'validates tweet is less than 250 characters' do
    #   invalid_article = build(:article, tweet: 'a' * 251)
    #   valid_article   = build(:article, tweet: 'a' * 250)
    #
    #   expect(valid_article).to be_valid
    #   expect(invalid_article).not_to be_valid
    # end

    it 'validates summary is less than 200 characters' do
      invalid_article = build(:article, summary: 'a' * 201)
      valid_article   = build(:article, summary: 'a' * 200)

      expect(valid_article).to be_valid
      expect(invalid_article).not_to be_valid
    end

    it 'replace \r\n with \n in tweet and summary' do
      new_article = build(:article,
                          tweet:   "ab\r\ncd" * 50,
                          summary: "a\r\nbc" * 50)

      expect(new_article).to be_valid
      expect(new_article.tweet.length).to eq(250)

      new_article.save!
      expect(new_article.reload).to be_valid
      expect(new_article.summary.length).to eq(200)
      expect(new_article.tweet.length).to eq(250)
    end
  end

  describe '#path' do
    subject { article.path }

    context 'when published' do
      let(:article) { create(:article, slug: 'slug', published_at: date, publication_status: 'published') }
      let(:date)    { Date.parse('2017-01-01') }

      it { is_expected.to eq('/2017/01/01/slug') }
    end

    context 'when not published' do
      let(:article) { create(:article, draft_code: 'draft-code', publication_status: 'draft') }

      it { is_expected.to eq('/drafts/articles/draft-code') }
    end
  end

  describe '#slug_exists?' do
    subject { article.slug_exists? }

    let(:article) { described_class.new(slug: 'slug', published_at: date, short_path: SecureRandom.hex, publication_status: 'published') }
    let(:date)    { Date.parse('2017-01-01') }

    context 'with the same slug on the same date' do
      before { create(:article, slug: 'slug', published_at: date, publication_status: 'published') }

      it { is_expected.to be true }
    end

    context 'with the same slug on a different date' do
      before { create(:article, slug: 'slug', published_at: date + 1.day, publication_status: 'published') }

      it { is_expected.to be false }
    end

    context 'with a unique slug' do
      before { create(:article, slug: 'another-slug', published_at: date, publication_status: 'published') }

      it { is_expected.to be false }
    end
  end

  # TODO: add new spec for saving tags
  # describe '#save_tags!' do
  #   it 'creates Tags and adds taggings' do
  #     tags = ['Tag 1', 'Tag 2']
  #
  #     article = Article.create(title: 'test')
  #     article.save_tags!(tags.join(', '))
  #
  #     expect(article.tags.map(&:name)).to match_array(tags)
  #   end
  #
  #   it 'deletes old taggings' do
  #     article = Article.create(title: 'test')
  #     article.save_tags!('')
  #
  #     expect(article.tags).to be_empty
  #   end
  # end

  describe '#collection_posts' do
    let(:published_at) { Date.current }

    it 'finds related collection_posts by collection_id' do
      collection = create(:article, title: 'test', publication_status: 'published', published_at: published_at)
      article = create(:article, title: 'test', collection_id: collection.id, publication_status: 'published', published_at: published_at)

      expect(collection.collection_posts).to include article
    end
  end

  describe 'collection_root?' do
    let(:published_at) { Date.current }

    context 'when #collection_posts exists' do
      it 'returns true' do
        collection = create(:article, title: 'test', publication_status: 'published', published_at: published_at)
        create(:article, title: 'test', collection_id: collection.id, publication_status: 'published', published_at: published_at)

        expect(collection.collection_root?).to be true
      end
    end

    context 'when zero #collection_posts exist' do
      it 'returns false' do
        article = create(:article, title: 'test', publication_status: 'published', published_at: published_at)

        expect(article.collection_root?).to be false
      end
    end
  end

  describe 'in_collection?' do
    let(:published_at) { Date.current }

    context 'when it has a collection_id' do
      it 'returns true' do
        collection = create(:article, title: 'test', publication_status: 'published', published_at: published_at)
        article = create(:article, title: 'test', collection_id: collection.id, publication_status: 'published', published_at: published_at)

        expect(article.in_collection?).to be true
      end
    end

    context 'when collection_id is nil' do
      it 'returns false' do
        article = create(:article, title: 'test', publication_status: 'published', published_at: published_at)

        expect(article.in_collection?).to be false
      end
    end
  end

  describe 'short_path_redirect_creation' do
    let(:published_at) { Date.current }

    context 'when it successfully creates a short_path redirect' do
      it 'returns true' do
        # TODO: FIXME: redo this test
        # article = create(:article, title: 'test', publication_status: 'published', published_at: published_at)
        # expect(Redirect.last.source_path[/\w+/]).to eq article.short_path
      end
    end

    context 'when it doesn’t create a short_path redirect if redirect exists' do
      it 'raises error' do
        # TODO: FIXME: redo this test
        # redirect = Redirect.create!(source_path: '/tester', target_path: '/test/test')
        # article = Article.new(title: 'test', collection_id: nil, short_path: 'tester', publication_status: 'published', published_at: published_at)
        # expect{article.save!}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Short path  is already defined by a redirect')
      end
    end
  end
end
