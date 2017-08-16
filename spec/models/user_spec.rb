require "rails_helper"

RSpec.describe User, type: :model do
  describe ".options_for_select" do
    let!(:user) { User.create(username: "example", password: "x" * 30) }

    subject { User.options_for_select }

    it { is_expected.to eq([["example", user.id]]) }
  end

  describe "#name" do
    subject { user.name }

    context "without display_name" do
      let(:user) { User.create(username: "example", password: "x" * 30) }

      it { is_expected.to eq("example") }
    end
  end
end
