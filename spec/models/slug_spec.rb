require 'rails_helper'

describe Slug do
  let(:model) { Page.new(title: 'test') }

  describe 'generating a new slug when slug exists' do
    subject { model.generate_slug }

    before { Page.create!(title: 'test') }

    it { is_expected.to eq('test-1') }
  end
end
