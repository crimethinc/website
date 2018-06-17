require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#name' do
    subject { book.name }

    context 'with a subtitle' do
      let(:book) { Book.new(title: 'title', subtitle: 'subtitle') }

      it { is_expected.to eq('title : subtitle') }
    end

    context 'without a subtitle' do
      let(:book) { Book.new(title: 'title') }

      it { is_expected.to eq('title') }
    end
  end

  describe '#path' do
    let(:book) { Book.new(slug: 'slug') }

    subject { book.path }

    it { is_expected.to eq('/books/slug') }
  end

  describe '#image' do
    subject { book.image(side: :front) }

    let(:book) { Book.new(slug: 'slug') }

    it { is_expected.to eq('https://cloudfront.crimethinc.com/assets/books/slug/slug_front.jpg') }
  end

  describe '#image_description' do
    subject { book.image_description }

    let(:book) { Book.new(title: 'Contradictionary') }

    it { is_expected.to eq('Photo of ‘Contradictionary’ front cover') }
  end

  describe '#published?' do
    subject { book.published? }

    let(:status) { Status.new(name: 'published') }
    let(:book) { Book.new(title: 'Contradictionary', status: status) }

    it { is_expected.to eq(true) }
  end

  describe '#tags' do
    let!(:book) { Book.create(title: 'title', subtitle: 'subtitle') }
    let!(:tag_1) { Tag.create(name: 'test 1', slug: 'test-1') }
    let!(:taggable) { Tagging.create(tag: tag_1, taggable: book) }

    it 'returns the tag' do
      expect(book.tags.map(&:id)).to eq([tag_1.id])
    end
  end
end
