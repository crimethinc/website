require 'rails_helper'

RSpec.describe Logo do
  describe '#published?' do
    it 'returns true when published' do
      logo = described_class.new(title: 'Logo', publication_status: 'published')

      expect(logo.published?).to be true
    end
  end

  describe '.image_formats' do
    it 'returns supported image formats' do
      expect(described_class.image_formats).to eq %i[jpg png tif svg pdf]
    end
  end

  describe '#meta_description' do
    it 'returns a description with the title' do
      logo = described_class.new(title: 'Star')

      expect(logo.meta_description).to eq 'CrimethInc. logo: Star'
    end
  end

  describe 'stub methods' do
    it 'returns nil for image and download stubs' do
      logo = described_class.new

      expect(logo.back_download_present?).to be_nil
      expect(logo.back_image_present?).to be_nil
      expect(logo.front_download_present?).to be_nil
    end

    it 'returns nil for attribute stubs' do
      logo = described_class.new

      expect(logo.buy_info).to be_nil
      expect(logo.content).to be_nil
      expect(logo.depth).to be_nil
      expect(logo.price_in_cents).to be_nil
    end
  end
end
