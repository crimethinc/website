require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '#path' do
    let(:video) { Video.new(slug: 'slug') }

    subject { video.path }

    it { is_expected.to eq('/videos/slug') }
  end

  describe '#published?' do
    subject { video.published? }

    let(:status) { Status.new(name: 'published') }
    let(:video) { Video.new(status: status) }

    it { is_expected.to eq(true) }
  end
end
