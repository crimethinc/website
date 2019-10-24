require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#name' do
    subject { book.name }

    context 'with a subtitle' do
      let(:book) { described_class.new(title: 'title', subtitle: 'subtitle') }

      it { is_expected.to eq('title : subtitle') }
    end

    context 'without a subtitle' do
      let(:book) { described_class.new(title: 'title') }

      it { is_expected.to eq('title') }
    end
  end

  describe '#path' do
    subject { book.path }

    let(:book) { described_class.new(slug: 'slug') }

    it { is_expected.to eq('/books/slug') }
  end

  describe '#image' do
    subject { book.image(side: :front) }

    let(:book) { described_class.new(slug: 'slug') }

    it { is_expected.to eq('https://cloudfront.crimethinc.com/assets/books/slug/slug_front.jpg') }
  end

  describe '#image_description' do
    subject { book.image_description }

    let(:book) { described_class.new(title: 'Contradictionary') }

    it { is_expected.to eq('Photo of ‘Contradictionary’ front cover') }
  end

  describe '#published?' do
    subject { book.published? }

    let(:book) { described_class.new(title: 'Contradictionary', publication_status: 'published') }

    it { is_expected.to eq(true) }
  end

  describe '#tags' do
    let(:book) { described_class.create(title: 'title', subtitle: 'subtitle') }
    let(:tag_1) { Tag.create(name: 'test 1', slug: 'test-1') }

    it 'returns the tag' do
      Tagging.create(tag: tag_1, taggable: book)

      expect(book.tags.map(&:id)).to eq([tag_1.id])
    end
  end
end
