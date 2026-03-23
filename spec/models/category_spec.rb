require 'rails_helper'

describe Category do
  describe '#path' do
    it 'returns the category path' do
      category = described_class.new(name: 'Technology', slug: 'technology')

      expect(category.path).to eq '/categories/technology'
    end
  end

  describe '#strip_whitespace' do
    it 'strips whitespace from name' do
      category = described_class.create!(name: '  Padded  ')

      expect(category.name).to eq 'Padded'
    end
  end

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
