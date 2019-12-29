require 'rails_helper'

RSpec.describe Locale, type: :model do
  describe '#english?' do
    let(:english_locale) { build :locale, :en }
    let(:spanish_locale) { build :locale, :es }

    it 'checks for englishness' do
      expect(english_locale).to be_english
      expect(spanish_locale).not_to be_english
    end
  end
end
