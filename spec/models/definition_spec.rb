require 'rails_helper'

RSpec.describe Definition do
  describe '#path' do
    it 'returns the contradictionary path with filed_under and slug' do
      definition = create(:definition, title: 'Anarchy', slug: 'anarchy')

      expect(definition.path).to eq '/books/contradictionary/definitions/a/anarchy'
    end
  end

  describe '#path_for_letter_scoped_slug' do
    it 'returns the contradictionary path with anchor' do
      definition = create(:definition, title: 'Anarchy', slug: 'anarchy')

      expect(definition.path_for_letter_scoped_slug).to eq '/books/contradictionary/definitions/a#anarchy'
    end
  end

  describe 'before_save callbacks' do
    it 'sets filed_under to the downcased first character of title' do
      definition = create(:definition, title: 'Borders')

      expect(definition.filed_under).to eq 'b'
    end

    it 'defaults publication_status to draft' do
      definition = create(:definition, title: 'Test')

      expect(definition.publication_status).to eq 'draft'
    end

    it 'keeps publication_status when already set' do
      definition = create(:definition, title: 'Test', publication_status: 'published')

      expect(definition.publication_status).to eq 'published'
    end
  end

  describe 'default_scope' do
    it 'orders by slug ascending' do
      create(:definition, title: 'Zebra', slug: 'zebra')
      create(:definition, title: 'Anarchy', slug: 'anarchy')

      expect(described_class.all.map(&:slug)).to eq %w[anarchy zebra]
    end
  end
end
