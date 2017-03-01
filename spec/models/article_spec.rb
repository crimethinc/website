require "rails_helper"

describe Article do
  describe "#path" do
    subject { article.path }

    context "published" do
      let(:article) { Article.new(slug: "slug", published_at: date, status: status, short_path: SecureRandom.hex) }
      let(:date)    { Date.parse("2017-01-01") }
      let(:status)  { Status.new(name: "published") }

      it { is_expected.to eq("/2017/01/01/slug") }
    end

    context "not published" do
      let(:article) { Article.new(draft_code: "draft-code", status: status, short_path: SecureRandom.hex) }
      let(:status)  { Status.new(name: "draft") }

      it { is_expected.to eq("/drafts/articles/draft-code") }
    end
  end

  describe "#slug_exists?" do
    Status.create!(name: "published")
    let(:published_at) { Date.current }
    let(:article) { Article.new(slug: "slug", published_at: date, short_path: SecureRandom.hex, status: Status.last, published_at: published_at) }
    let(:date)    { Date.parse("2017-01-01") }

    subject { article.slug_exists? }

    context "with the same slug on the same date" do
      before { Article.create(slug: "slug", published_at: date, short_path: SecureRandom.hex, status: Status.last, published_at: published_at) }

      it { is_expected.to be true }
    end

    context "with the same slug on a different date" do
      before { Article.create(slug: "slug", published_at: date + 1.day, short_path: SecureRandom.hex, status: Status.last, published_at: published_at) }

      it { is_expected.to be false }
    end

    context "with a unique slug" do
      before { Article.create(slug: "another-slug", short_path: SecureRandom.hex, status: Status.last, published_at: date) }

      it { is_expected.to be false }
    end
  end

  # TODO add new spec for saving tags
  # describe "#save_tags!" do
  #   it "creates Tags and adds taggings" do
  #     tags = ["Tag 1", "Tag 2"]
  #
  #     article = Article.create(title: 'test')
  #     article.save_tags!(tags.join(", "))
  #
  #     expect(article.tags.map(&:name)).to match_array(tags)
  #   end
  #
  #   it "deletes old taggings" do
  #     article = Article.create(title: 'test')
  #     article.save_tags!("")
  #
  #     expect(article.tags).to be_empty
  #   end
  # end

  describe "#collection_posts" do
    let(:status)  { Status.new(name: "published") }
    let(:published_at) { Date.current }
    it "finds related collection_posts by collection_id" do
      collection = Article.create(title: 'test', short_path: SecureRandom.hex, status: status, published_at: published_at)
      article = Article.create(title: 'test', collection_id: collection.id, short_path: SecureRandom.hex, status: status, published_at: published_at)

      expect(collection.collection_posts).to include article
    end
  end

  describe "collection_root?" do
    let(:status)  { Status.new(name: "published") }
    let(:published_at) { Date.current }
    context "when #collection_posts exists" do
      it "returns true" do
        collection = Article.create(title: 'test', short_path: SecureRandom.hex, status: status, published_at: published_at)
        Article.create(title: 'test', collection_id: collection.id, short_path: SecureRandom.hex, status: status, published_at: published_at)

        expect(collection.collection_root?).to eq true
      end
    end
    context "when zero #collection_posts exist" do
      it "returns false" do
        article = Article.create(title: 'test', short_path: SecureRandom.hex, status: status, published_at: published_at)

        expect(article.collection_root?).to eq false
      end
    end
  end

  describe "in_collection?" do
    let(:status)  { Status.new(name: "published") }
    let(:published_at) { Date.current }
    context "when it has a collection_id" do
      it "returns true" do
        collection = Article.create(title: 'test', short_path: SecureRandom.hex, status: status, published_at: published_at)
        article = Article.create(title: 'test', collection_id: collection.id, short_path: SecureRandom.hex, status: status, published_at: published_at)

        expect(article.in_collection?).to eq true
      end
    end
    context "when collection_id is nil" do
      it "returns false" do
        article = Article.create(title: 'test', collection_id: nil, short_path: SecureRandom.hex, status: status, published_at: published_at)

        expect(article.in_collection?).to eq false
      end
    end
  end
end
