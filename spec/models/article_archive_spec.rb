require 'rails_helper'

RSpec.describe ArticleArchive do
  describe 'it sorts the articles correctly' do
    subject { described_class.new(year: '2017', month: '01').first }

    let!(:first) { create(:article, published_at: Date.parse('2017-01-01'), publication_status: 'published') }
    let!(:last) { create(:article, published_at: Date.parse('2017-01-20'), publication_status: 'published') }

    it { is_expected.to eq([2017, { 1 => [last, first] }]) }
  end

  describe '#paginator' do
    it 'returns an ArticleArchivePaginator' do
      archive = described_class.new(year: '2017', month: '01')

      expect(archive.paginator).to be_a ArticleArchivePaginator
    end
  end
end
