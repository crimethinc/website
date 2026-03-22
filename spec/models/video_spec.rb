require 'rails_helper'

RSpec.describe Video do
  describe '#path' do
    subject { video.path }

    let(:video) { described_class.new(slug: 'slug') }

    it { is_expected.to eq('/videos/slug') }
  end

  describe '#ask_for_donation?' do
    it 'returns false' do
      expect(described_class.new.ask_for_donation?).to be false
    end
  end

  describe '#meta_image' do
    it 'returns an empty string' do
      expect(described_class.new.meta_image).to eq ''
    end
  end

  describe '#download_url' do
    it 'returns the vimeo download url' do
      video = described_class.new(vimeo_id: '12345')

      expect(video.download_url).to eq 'https://vimeo.com/12345#download'
    end
  end

  describe '#video_url' do
    it 'returns vimeo url by default' do
      video = described_class.new(vimeo_id: '12345')

      expect(video.video_url).to eq 'https://vimeo.com/12345'
    end

    it 'returns peer_tube_url when present' do
      video = described_class.new(vimeo_id: '12345', peer_tube_url: 'https://pt.example.com/w/abc')

      expect(video.video_url).to eq 'https://pt.example.com/w/abc'
    end
  end

  describe '#published?' do
    subject { video.published? }

    let(:video) { described_class.new(publication_status: 'published') }

    it { is_expected.to be(true) }
  end
end
