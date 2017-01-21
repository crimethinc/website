require "rails_helper"

RSpec.describe User, type: :model do
  describe ".options_for_select" do
    let!(:user) { User.create(username: "example", display_name: "Example Name", password: "x" * 30) }

    subject { User.options_for_select }

    it { is_expected.to eq([["@example (Example Name)", user.id]]) }
  end

  describe "#name" do
    subject { user.name }

    context "with display_name" do
      let(:user) { User.create(username: "example", display_name: "Example Name", password: "x" * 30) }

      it { is_expected.to eq("Example Name") }
    end

    context "without display_name" do
      let(:user) { User.create(username: "example", password: "x" * 30) }

      it { is_expected.to eq("example") }
    end
  end
end
