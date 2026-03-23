require 'rails_helper'

RSpec.describe EbookFormat do
  describe '.all' do
    it 'returns ebook formats from i18n' do
      formats = described_class.all

      expect(formats).to be_an Array
      expect(formats).not_to be_empty
      expect(formats.first).to respond_to(:slug, :name, :description)
    end
  end
end
