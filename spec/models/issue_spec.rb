require 'rails_helper'

RSpec.describe Issue do
  describe '#namespace' do
    it 'returns journals' do
      issue = build(:issue)

      expect(issue.namespace).to eq 'journals'
    end
  end

  describe '#path' do
    it 'returns the journal and issue path' do
      journal = create(:journal, slug: 'rolling-thunder')
      issue = create(:issue, journal: journal, issue: '3')

      expect(issue.path).to eq '/journals/rolling-thunder/3'
    end
  end

  describe '#false_for_missing_methods' do
    it 'returns false' do
      issue = build(:issue)

      expect(issue.front_color_image_present?).to be false
      expect(issue.back_color_image_present?).to be false
      expect(issue.front_color_download_present?).to be false
      expect(issue.back_color_download_present?).to be false
    end
  end
end
