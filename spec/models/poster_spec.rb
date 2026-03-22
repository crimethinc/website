require 'rails_helper'

RSpec.describe Poster do
  describe '#published?' do
    subject { poster.published? }

    let(:poster) { described_class.new(title: 'Poster', publication_status: 'published') }

    it { is_expected.to be(true) }
  end

  describe '#meta_image' do
    it 'returns nil when no images are attached' do
      poster = create(:poster)

      expect(poster.meta_image).to be_nil
    end

    it 'returns a URL when front color image is attached' do
      poster = create(:poster)
      poster.image_front_color_image.attach(
        io:           Rails.root.join('spec/fixtures/files/test_image.jpg').open,
        filename:     'test.jpg',
        content_type: 'image/jpeg'
      )

      expect(poster.meta_image).to be_present
    end
  end

  describe '#front_image' do
    it 'returns nil when no images are attached' do
      poster = create(:poster)

      expect(poster.front_image).to be_nil
    end
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
