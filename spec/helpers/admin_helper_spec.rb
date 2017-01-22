require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  describe "#thing_type" do
    before { expect(helper.request).to receive(:path) { "admin/things/id" } }

    subject { helper.thing_type(nil) }

    it { is_expected.to eq("Thing") }
  end
end
