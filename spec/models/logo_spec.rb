require 'rails_helper'

RSpec.describe Logo do
  describe '#published?' do
    subject { logo.published? }

    let(:logo) { described_class.new(title: 'Logo', publication_status: 'published') }

    it { is_expected.to be(true) }
  end
end
