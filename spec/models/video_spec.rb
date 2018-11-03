require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '#path' do
    subject { video.path }

    let(:video) { Video.new(slug: 'slug') }

    it { is_expected.to eq('/videos/slug') }
  end

  describe '#published?' do
    subject { video.published? }

    let(:video) { Video.new(publication_status: 'published') }

    it { is_expected.to eq(true) }
  end
end
