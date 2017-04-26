require "rails_helper"

RSpec.describe Archive, type: :model do
  describe "it sorts the articles correctly" do
    Status.delete_all
    let(:status)  { FactoryGirl.create(:status) }
    let!(:first) { FactoryGirl.create(:article, published_at: DateTime.parse("2017-01-01"), status: status) }
    let!(:last) { FactoryGirl.create(:article, published_at: DateTime.parse("2017-01-20"), status: status) }

    subject { Archive.new(year: "2017", month: "01").first }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end
end
