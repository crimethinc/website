require 'rails_helper'

RSpec.describe ArticleArchivePaginator do
  before do
    create(:article, published_at: Time.zone.parse('2022-06-15'), publication_status: 'published')
    create(:article, published_at: Time.zone.parse('2023-03-10'), publication_status: 'published')
    create(:article, published_at: Time.zone.parse('2024-09-20'), publication_status: 'published')
  end

  describe 'year-based pagination' do
    let(:archive) { ArticleArchive.new(year: '2023', month: nil) }
    let(:paginator) { described_class.new(archive) }

    it 'has a previous year' do
      expect(paginator.previous?).to be true
      expect(paginator.previous_path).to eq '/2022'
    end

    it 'has a next year' do
      expect(paginator.next?).to be true
      expect(paginator.next_path).to eq '/2024'
    end

    it 'returns year labels' do
      expect(paginator.previous_label).to be_present
      expect(paginator.next_label).to be_present
    end
  end

  describe 'month-based pagination' do
    before do
      create(:article, published_at: Time.zone.parse('2023-01-05'), publication_status: 'published')
      create(:article, published_at: Time.zone.parse('2023-06-15'), publication_status: 'published')
    end

    let(:archive) { ArticleArchive.new(year: '2023', month: '03') }
    let(:paginator) { described_class.new(archive) }

    it 'has a previous month' do
      expect(paginator.previous?).to be true
    end

    it 'has a next month' do
      expect(paginator.next?).to be true
    end

    it 'returns month labels' do
      expect(paginator.previous_label).to be_present
      expect(paginator.next_label).to be_present
    end
  end
end
