require 'rails_helper'

describe Article do
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
        article = Article.create(title: 'test', collection_id: collection.id)

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
