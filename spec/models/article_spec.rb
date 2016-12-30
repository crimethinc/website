require 'rails_helper'

describe Article do
  describe "#articles" do
    it "finds related articles by parent_id" do
      collection = Article.create(title: 'test')
      article = Article.create(title: 'test', parent_id: collection.id)

      expect(collection.articles).to include article
    end
  end

  describe "collection_root?" do
    context "when #articles exists" do
      it "returns true" do
        collection = Article.create(title: 'test')
        article = Article.create(title: 'test', parent_id: collection.id)

        expect(collection.collection_root?).to eq true
      end
    end
    context "when zero #articles exist" do
      it "returns false" do
        article = Article.create(title: 'test')

        expect(article.collection_root?).to eq false
      end
    end
  end

  describe "in_collection?" do
    context "when it has a parent_id" do
      it "returns true" do
        collection = Article.create(title: 'test')
        article = Article.create(title: 'test', parent_id: collection.id)

        expect(article.in_collection?).to eq true
      end
    end
    context "when parent_id is nil" do
      it "returns false" do
        article = Article.create(title: 'test', parent_id: nil)

        expect(article.in_collection?).to eq false
      end
    end
  end
end
