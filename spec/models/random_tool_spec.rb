require 'rails_helper'

RSpec.describe RandomTool do
  describe '#sample' do
    it 'gets a random tool from the database' do
      # Create test data for each tool type
      create(:book, publication_status: 'published', published_at: 1.day.ago)
      create(:logo, publication_status: 'published', published_at: 1.day.ago)
      create(:poster, publication_status: 'published', published_at: 1.day.ago)
      create(:sticker, publication_status: 'published', published_at: 1.day.ago)
      create(:video, publication_status: 'published', published_at: 1.day.ago)
      create(:zine, publication_status: 'published', published_at: 1.day.ago)

      tool_classes = %w[Book Logo Poster Sticker Video Zine]

      tool = described_class.sample
      expect(tool_classes).to include(tool.class.name)
      expect(tool).to be_persisted
    end
  end
end
