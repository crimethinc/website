require "rails_helper"

describe Article do
  describe "#path" do
    subject { article.path }

    context "published" do
      let(:article) { FactoryGirl.create(:article, slug: "slug", published_at: date, status: status) }
      let(:date)    { Date.parse("2017-01-01") }
      let(:status)  { FactoryGirl.create(:status) }

      it { is_expected.to eq("/2017/01/01/slug") }
    end

    context "not published" do
      let(:article) { FactoryGirl.create(:article, draft_code: "draft-code", status: status) }
      let(:status)  { FactoryGirl.create(:status, name: "draft") }

      it { is_expected.to eq("/drafts/articles/draft-code") }
    end
  end

  describe "#slug_exists?" do
    let(:status)  { FactoryGirl.create(:status) }
    let(:article) { Article.new(slug: "slug", published_at: date, short_path: SecureRandom.hex, status: Status.last) }
    let(:date)    { Date.parse("2017-01-01") }

    subject { article.slug_exists? }

    context "with the same slug on the same date" do
      before { FactoryGirl.create(:article, slug: "slug", published_at: date, status: status) }

      it { is_expected.to be true }
    end

    context "with the same slug on a different date" do
      before { FactoryGirl.create(:article, slug: "slug", published_at: date + 1.day, status: status) }

      it { is_expected.to be false }
    end

    context "with a unique slug" do
      before { FactoryGirl.create(:article, slug: "another-slug", published_at: date, status: status) }

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
    let(:status)  { FactoryGirl.create(:status) }
    let(:published_at) { Date.current }
    it "finds related collection_posts by collection_id" do
      collection = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)
      article = FactoryGirl.create(:article, title: 'test', collection_id: collection.id, status: status, published_at: published_at)

      expect(collection.collection_posts).to include article
    end
  end

  describe "collection_root?" do
    let(:status)  { FactoryGirl.create(:status) }
    let(:published_at) { Date.current }
    context "when #collection_posts exists" do
      it "returns true" do
        collection = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)
        article = FactoryGirl.create(:article, title: 'test', collection_id: collection.id, status: status, published_at: published_at)

        expect(collection.collection_root?).to eq true
      end
    end
    context "when zero #collection_posts exist" do
      it "returns false" do
        article = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)

        expect(article.collection_root?).to eq false
      end
    end
  end

  describe "in_collection?" do
    let(:status)  { FactoryGirl.create(:status) }
    let(:published_at) { Date.current }
    context "when it has a collection_id" do
      it "returns true" do
        collection = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)
        article = FactoryGirl.create(:article, title: 'test', collection_id: collection.id, status: status, published_at: published_at)

        expect(article.in_collection?).to eq true
      end
    end
    context "when collection_id is nil" do
      it "returns false" do
        article = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)

        expect(article.in_collection?).to eq false
      end
    end
  end

  describe "short_path_redirect_creation" do
    let(:status)  { FactoryGirl.create(:status) }
    let(:published_at) { Date.current }
    context "successfull creates a short_path redirect" do
      it "returns true" do
        article = FactoryGirl.create(:article, title: 'test', status: status, published_at: published_at)
        # expect(Redirect.last.source_path[/\w+/]).to eq article.short_path
      end
    end

    context "doesn't create a short_path redirect if redirect exists" do
      it "should raise error" do
        redirect = Redirect.create!(source_path: "/tester", target_path: "/test/test")
        article = Article.new(title: 'test', collection_id: nil, short_path: "tester", status: status, published_at: published_at)
        # expect{article.save!}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Short path  is already defined by a redirect')
      end
    end
  end
end
