require 'rails_helper'

RSpec.describe ArticleArchive, type: :model do
  describe 'it sorts the articles correctly' do
    subject { ArticleArchive.new(year: '2017', month: '01').first }

    let!(:first) { create(:article, published_at: Date.parse('2017-01-01'), publication_status: 'published') }
    let!(:last) { create(:article, published_at: Date.parse('2017-01-20'), publication_status: 'published') }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end
end
