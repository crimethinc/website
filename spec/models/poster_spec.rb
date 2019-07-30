require 'rails_helper'

RSpec.describe Poster, type: :model do
  describe '#published?' do
    subject { poster.published? }

    let(:poster) { described_class.new(title: 'Poster', publication_status: 'published') }

    it { is_expected.to eq(true) }
  end

  describe '#tags' do
    let(:poster) { described_class.create(title: 'title', subtitle: 'subtitle') }
    let(:tag_1) { Tag.create(name: 'test 1', slug: 'test-1') }

    it 'returns the tag' do
      Tagging.create(tag: tag_1, taggable: poster)

      expect(poster.tags.map(&:id)).to eq([tag_1.id])
    end
  end
end
