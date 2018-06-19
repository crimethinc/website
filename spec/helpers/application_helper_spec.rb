require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#largest_touch_icon_url' do
    subject { helper.largest_touch_icon_url }

    it { is_expected.to match('icons/icon-600x600') }
  end
end
