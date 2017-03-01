require "rails_helper"

RSpec.describe Archive, type: :model do
  describe "it sorts the articles correctly" do
    let(:status)  { Status.new(name: "published") }
    let!(:first) { create(:article, published_at: DateTime.parse("2017-01-01"), status: status, short_path: SecureRandom.hex) }
    let!(:last) { create(:article, published_at: DateTime.parse("2017-01-20"), status: status, short_path: SecureRandom.hex) }
    byebug
    subject { Archive.new(year: "2017", month: "01").first }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end
end
