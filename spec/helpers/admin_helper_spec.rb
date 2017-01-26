require "rails_helper"

RSpec.describe AdminHelper, type: :helper do
  describe "#current_resource_name" do
    before { expect(helper.request).to receive(:path) { "admin/things/id" } }

    subject { helper.current_resource_name }

    it { is_expected.to eq("Thing") }
  end
end
