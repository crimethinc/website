require 'rails_helper'

describe Slug do
  let(:model) { Page.new(title: 'test') }

  describe 'generating a new slug when slug exists' do
    subject { model.generate_slug }

    before { Page.create!(title: 'test') }

    it { is_expected.to eq('test-1') }
  end

  describe '#formatted_slug' do
    it 'returns [slug] for new records' do
      page = Page.new(title: 'test')

      expect(page.formatted_slug).to eq '[slug]'
    end

    it 'returns the slug for persisted records' do
      page = Page.create!(title: 'test')

      expect(page.formatted_slug).to eq 'test'
    end
  end
end
