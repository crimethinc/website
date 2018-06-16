require 'rails_helper'

RSpec.describe Poster, type: :model do
  describe '#published?' do
    subject { poster.published? }

    let(:status) { Status.new(name: 'published') }
    let(:poster) { Poster.new(title: 'Poster', status: status) }

    it { is_expected.to eq(true)}
  end

  describe '#tags' do
    let!(:poster) { Poster.create(title: 'title', subtitle: 'subtitle') }
    let!(:tag_1) { Tag.create(name: 'test 1', slug: 'test-1') }
    let!(:taggable) { Tagging.create(tag: tag_1, taggable: poster) }

    it 'returns the tag' do
      expect(poster.tags.map(&:id)).to eq([tag_1.id])
    end
  end
end
