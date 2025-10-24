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

  describe '#after_save' do
    let(:article) { build(:article) }
    let(:locale) { Locale.find_by abbreviation: article.locale }

    context 'when the article has an associated locale' do
      it 'updates the locale\'s articles_count cache value' do
        # pre-condition: before the article is saved the locale's
        # cache value should be 0
        expect(locale.articles_count).to eq 0

        article.save

        expect(locale.reload.articles_count).to eq 1
      end
    end

    context 'when an article has its associated locale changed' do
      let(:new_locale) { create(:locale, :gl) }

      before { article.save }

      it 'updates both locale\'s articles_count cache value' do
        # pre-condition: before the article's locale is changed
        expect(locale.articles_count).to eq 1
        expect(new_locale.articles_count).to eq 0

        article.update!(locale: new_locale.abbreviation)

        expect(locale.reload.articles_count).to eq 0
        expect(new_locale.reload.articles_count).to eq 1
      end
    end
  end

  describe '#after_destroy' do
    let(:article) { build(:article) }
    let(:locale) { Locale.find_by abbreviation: article.locale }

    context 'when the article has an associated locale' do
      before { article.save! }

      it 'decrements the locale\'s articles_count cache value' do
        # pre-condition: before the article is destroyed the locale's
        # cache value should be 1
        expect(locale.articles_count).to eq 1

        article.destroy

        expect(locale.reload.articles_count).to eq 0
      end
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

    let(:article) do
      described_class.new(
        slug:               'slug',
        published_at:       date,
        short_path:         SecureRandom.hex,
        publication_status: 'published'
      )
    end

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
      collection = create(
        :article,
        title:              'test',
        publication_status: 'published',
        published_at:       published_at
      )

      article = create(
        :article,
        title:              'test',
        collection_id:      collection.id,
        publication_status: 'published',
        published_at:       published_at
      )

      expect(collection.collection_posts).to include article
    end
  end

  describe 'collection_root?' do
    let(:published_at) { Date.current }

    context 'when #collection_posts exists' do
      it 'returns true' do
        collection = create(
          :article,
          title:              'test',
          publication_status: 'published',
          published_at:       published_at
        )

        create(
          :article,
          title:              'test',
          collection_id:      collection.id,
          publication_status: 'published',
          published_at:       published_at
        )

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
        collection = create(
          :article,
          title:              'test',
          publication_status: 'published',
          published_at:       published_at
        )

        article = create(
          :article,
          title:              'test',
          collection_id:      collection.id,
          publication_status: 'published',
          published_at:       published_at
        )

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
      it 'returns true', skip: 'Fix this test' do
        # TODO: FIXME: redo this test

        article = create(
          :article,
          title:              'test',
          publication_status: 'published',
          published_at:       published_at
        )

        expect(Redirect.last.source_path[/\w+/]).to eq article.short_path
      end
    end

    context 'when it doesn’t create a short_path redirect if redirect exists' do
      it 'raises error', skip: 'Fix this test' do
        # TODO: FIXME: redo this test
        Redirect.create!(source_path: '/tester', target_path: '/test/test')

        article = described_class.new(
          title:              'test',
          collection_id:      nil,
          short_path:         'tester',
          publication_status: 'published',
          published_at:       published_at
        )

        error_message = 'Validation failed: Short path is already defined by a redirect'
        expect { article.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
      end
    end
  end
end
