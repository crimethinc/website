require 'rails_helper'

RSpec.describe TagsHelper do
  describe '#tool_language_direction' do
    it 'returns the language direction for the tool locale' do
      create(:locale, :en)
      assign(:tool, build(:video, locale: 'en'))

      expect(helper.tool_language_direction).to eq 'ltr'
    end

    it 'falls back to i18n default when no tool' do
      expect(helper.tool_language_direction).to eq I18n.t('language_direction')
    end
  end
end
