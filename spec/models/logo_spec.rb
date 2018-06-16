require 'rails_helper'

RSpec.describe Logo, type: :model do
    describe '#published?' do
    subject { logo.published? }

    let(:status) { Status.new(name: 'published') }
    let(:logo) { Logo.new(title: 'Logo', status: status) }

    it { is_expected.to eq(true)}
  end
end