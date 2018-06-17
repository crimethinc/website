require 'rails_helper'

RSpec.describe ArticleArchive, type: :model do
  describe 'it sorts the articles correctly' do
    Status.delete_all
    let(:status) { create(:status, :published) }
    let!(:first) { create(:article, published_at: Date.parse('2017-01-01'), status: status) }
    let!(:last) { create(:article, published_at: Date.parse('2017-01-20'), status: status) }

    subject { ArticleArchive.new(year: '2017', month: '01').first }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end
end
