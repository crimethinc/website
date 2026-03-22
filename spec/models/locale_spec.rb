require 'rails_helper'

RSpec.describe Locale do
  describe '.current' do
    it 'returns the current I18n locale' do
      expect(described_class.current).to eq I18n.locale
    end
  end

  describe '#title' do
    it 'returns the name' do
      locale = build(:locale, :en)

      expect(locale.title).to eq locale.name
    end
  end

  describe '#english?' do
    let(:english_locale) { build(:locale, :en) }
    let(:spanish_locale) { build(:locale, :es) }

    it 'checks for englishness' do
      expect(english_locale).to be_english
      expect(spanish_locale).not_to be_english
    end
  end

  describe '#display_name' do
    let(:english_locale) { build(:locale, :en) }
    let(:spanish_locale) { build(:locale, :es) }

    it 'formats for display' do
      expect(english_locale.display_name).to eq 'EN : English / English'
      expect(spanish_locale.display_name).to eq 'ES : Spanish / Español'
    end
  end
end
