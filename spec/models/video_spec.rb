require 'rails_helper'

RSpec.describe Video do
  describe '#path' do
    subject { video.path }

    let(:video) { described_class.new(slug: 'slug') }

    it { is_expected.to eq('/videos/slug') }
  end

  describe '#published?' do
    subject { video.published? }

    let(:video) { described_class.new(publication_status: 'published') }

    it { is_expected.to be(true) }
  end
end
