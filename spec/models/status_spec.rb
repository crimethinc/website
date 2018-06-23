require 'rails_helper'

RSpec.describe Status, type: :model do
  describe '.options_for_select' do
    subject { Status.options_for_select }

    let!(:status) { Status.create(name: 'status') }

    it { is_expected.to eq([['Status', status.id]]) }
  end
end
