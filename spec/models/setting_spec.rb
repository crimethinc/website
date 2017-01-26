require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe "#content" do
    subject { setting.content }

    context "with saved_content" do
      let(:setting) { Setting.new(name: "setting", fallback: "fallback", saved_content: "saved") }

      it { is_expected.to eq("saved") }
    end

    context "with no saved_content" do
      let(:setting) { Setting.new(name: "setting", fallback: "fallback") }

      it { is_expected.to eq("fallback") }
    end
  end

  describe "#generate_slug" do
    let(:setting) { Setting.new(name: "test setting") }

    subject { setting.generate_slug }

    it { is_expected.to eq("test_setting") }
  end
end
