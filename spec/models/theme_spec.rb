require 'rails_helper'

RSpec.describe Theme, type: :model do
  describe "#strip_whitespace" do
    let(:theme) { Theme.new(name: " name ").tap { |t| t.valid? } }

    subject { theme.name }

    it { is_expected.to eq("name") }
  end
end
