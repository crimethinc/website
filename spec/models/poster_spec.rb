require 'rails_helper'

RSpec.describe Poster do
  describe '#published?' do
    subject { poster.published? }

    let(:poster) { described_class.new(title: 'Poster', publication_status: 'published') }

    it { is_expected.to be(true) }
  end

  describe '#tags' do
    let(:poster) { described_class.create(title: 'title', subtitle: 'subtitle') }
    let(:first_tag) { Tag.create(name: 'test 1', slug: 'test-1') }

    it 'returns the tag' do
      Tagging.create(tag: first_tag, taggable: poster)

      expect(poster.tags.map(&:id)).to eq([first_tag.id])
    end
  end
end
