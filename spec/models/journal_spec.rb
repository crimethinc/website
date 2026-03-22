require 'rails_helper'

RSpec.describe Journal do
  describe '#path' do
    it 'returns the journal path with slug' do
      journal = create(:journal, slug: 'rolling-thunder')

      expect(journal.path).to eq '/journals/rolling-thunder'
    end
  end

  describe '#meta_description' do
    it 'returns description when present' do
      journal = create(:journal, description: 'A journal of dangerous living', subtitle: 'Subtitle')

      expect(journal.meta_description).to eq 'A journal of dangerous living'
    end

    it 'falls back to subtitle when description is blank' do
      journal = create(:journal, description: nil, subtitle: 'A subtitle')

      expect(journal.meta_description).to eq 'A subtitle'
    end
  end

  describe '#first_published_in' do
    it 'returns the year of the earliest issue' do
      journal = create(:journal)
      create(:issue, journal: journal, published_at: Time.zone.parse('2007-06-01'))
      create(:issue, journal: journal, issue: '2', slug: 'issue-2', published_at: Time.zone.parse('2010-01-01'))

      expect(journal.first_published_in).to eq 2007
    end
  end

  describe '#last_published_in' do
    it 'returns the year of the most recent issue' do
      journal = create(:journal)
      create(:issue, journal: journal, published_at: Time.zone.parse('2007-06-01'))
      create(:issue, journal: journal, issue: '2', slug: 'issue-2', published_at: Time.zone.parse('2010-01-01'))

      expect(journal.last_published_in).to eq 2010
    end
  end

  describe '#false_for_missing_methods' do
    it 'returns false for aliased stub methods' do
      journal = described_class.new

      expect(journal.back_image_present?).to be false
      expect(journal.width).to be false
      expect(journal.height).to be false
    end
  end
end
