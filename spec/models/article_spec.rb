require "rails_helper"

describe Article do
  describe "#path" do
    subject { article.path }

    context "published" do
      let(:article) { Article.new(slug: "slug", published_at: date, status: status) }
      let(:date)    { Date.parse("2017-01-01") }
      let(:status)  { Status.new(name: "published") }

      it { is_expected.to eq("/2017/01/01/slug") }
    end

    context "not published" do
      let(:article) { Article.new(draft_code: "draft-code", status: status) }
      let(:status)  { Status.new(name: "draft") }

      it { is_expected.to eq("/drafts/articles/draft-code") }
    end
  end

  describe "#slug_exists?" do
    let(:article) { Article.new(slug: "slug", published_at: date) }
    let(:date)    { Date.parse("2017-01-01") }

    subject { article.slug_exists? }

    context "with the same slug on the same date" do
      before { Article.create(slug: "slug", published_at: date) }

      it { is_expected.to be true }
    end

    context "with the same slug on a different date" do
      before { Article.create(slug: "slug", published_at: date + 1.day) }

      it { is_expected.to be false }
    end

    context "with a unique slug" do
      before { Article.create(slug: "another-slug") }

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

  describe "#save_categories!" do
    it "creates Categories and adds categorizations" do
      categories = ["Tag 1", "Tag 2"]

      article = Article.create(title: 'test')
      article.save_categories!(categories.join(", "))

      expect(article.categories.map(&:name)).to match_array(categories)
    end

    it "deletes old categorizations" do
      article = Article.create(title: 'test')
      article.save_categories!("")

      expect(article.categories).to be_empty
    end
  end

  describe "#collection_posts" do
    it "finds related collection_posts by collection_id" do
      collection = Article.create(title: 'test')
      article = Article.create(title: 'test', collection_id: collection.id)

      expect(collection.collection_posts).to include article
    end
  end

  describe "collection_root?" do
    context "when #collection_posts exists" do
      it "returns true" do
        collection = Article.create(title: 'test')
        Article.create(title: 'test', collection_id: collection.id)

        expect(collection.collection_root?).to eq true
      end
    end
    context "when zero #collection_posts exist" do
      it "returns false" do
        article = Article.create(title: 'test')

        expect(article.collection_root?).to eq false
      end
    end
  end

  describe "in_collection?" do
    context "when it has a collection_id" do
      it "returns true" do
        collection = Article.create(title: 'test')
        article = Article.create(title: 'test', collection_id: collection.id)

        expect(article.in_collection?).to eq true
      end
    end
    context "when collection_id is nil" do
      it "returns false" do
        article = Article.create(title: 'test', collection_id: nil)

        expect(article.in_collection?).to eq false
      end
    end
  end
end
