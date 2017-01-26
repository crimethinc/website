require "rails_helper"

RSpec.describe Video, type: :model do
  describe "#path" do
    let(:video) { Video.new(slug: "slug") }

    subject { video.path }

    it { is_expected.to eq("/videos/slug") }
  end
end
