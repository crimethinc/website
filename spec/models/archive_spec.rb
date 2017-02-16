require "rails_helper"

RSpec.describe Archive, type: :model do
  describe "it sorts the articles correctly" do
    let!(:first) { create(:article, published_at: DateTime.parse("2017-01-01")) }
    let!(:last) { create(:article, published_at: DateTime.parse("2017-01-20")) }

    subject { Archive.new(year: "2017", month: "01").first }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end
end
