require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#largest_touch_icon_url' do
    subject { helper.largest_touch_icon_url }

    it { is_expected.to match('icons/icon-600x600') }
  end

  describe '#tt' do
    it 'returns a themed translation' do
      Current.theme = '2017'

      expect(helper.tt('site_name')).to be_present
    end
  end
end
