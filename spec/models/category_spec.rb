require 'rails_helper'

describe Category do
  describe 'description' do
    it 'is optional' do
      category = described_class.new(name: 'no-description')
      expect(category).to be_valid
    end

    it 'can be set' do
      category = described_class.create!(name: 'with-description', description: 'A category about things')
      expect(category.reload.description).to eq('A category about things')
    end
  end
end
