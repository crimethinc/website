require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#largest_touch_icon_url' do
    let(:stub_asset) { 'rails asset url' }

    before do
      allow(helper).to receive(:asset_url).and_return(stub_asset)
    end

    it 'fetches the expected icon size' do
      expect(helper.largest_touch_icon_url).to eq stub_asset
      expect(helper).to have_received(:asset_url).with('icons/icon-600x600.png').once
    end
  end

  describe '#tt' do
    let(:stub_translation) { 'i18n translation' }
    let(:theme) { '2044' }

    before do
      Current.theme = theme
      allow(helper).to receive(:t).and_return(stub_translation)
    end

    it 'calls rails\' translation helper with the current theme' do
      expect(helper.tt('site_name')).to eq stub_translation
      expect(helper).to have_received(:t).with(start_with("#{theme}."))
    end
  end
end
