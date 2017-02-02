require "rails_helper"

RSpec.describe Book, type: :model do
  describe "#name" do
    subject { book.name }

    context "with a subtitle" do
      let(:book) { Book.new(title: "title", subtitle: "subtitle") }

      it { is_expected.to eq("title : subtitle") }
    end

    context "without a subtitle" do
      let(:book) { Book.new(title: "title") }

      it { is_expected.to eq("title") }
    end
  end

  describe "#path" do
    let(:book) { Book.new(slug: "slug") }

    subject { book.path }

    it { is_expected.to eq("/books/slug")}
  end

  describe "#image" do
    subject { book.image }

    let(:book) { Book.new(slug: "slug") }

    it { is_expected.to eq("https://cloudfront.crimethinc.com/assets/books/slug/photo.jpg") }
  end

  describe "#image_description" do
    subject { book.image_description }

    let(:book) { Book.new(title: "Contradictionary") }

    it { is_expected.to eq("Photo of 'Contradictionary' book cover") }
    end
end
