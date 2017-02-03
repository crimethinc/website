require "rails_helper"

RSpec.describe Status, type: :model do
  describe ".options_for_select" do
    let!(:status) { Status.create(name: "status") }

    subject { Status.options_for_select }

    it { is_expected.to eq([["Status", status.id]]) }
  end
end
