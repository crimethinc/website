require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#page_title" do
    context "with title" do
      before { assign(:title, "title") }

      subject { helper.page_title }

      it { is_expected.to eq("CrimethInc. : title")}
    end

    context "without title" do
      subject { helper.page_title }

      it { is_expected.to eq("CrimethInc.")}
    end
  end

  describe "#largest_touch_icon_url" do
    subject { helper.largest_touch_icon_url }

    it { is_expected.to match("icons/icon-600x600") }
  end

  describe "#homepage" do
    subject { helper.homepage? }

    context "with homepage set" do
      before { assign(:homepage, true) }

      it { is_expected.to eq(true) }
    end

    context "without homepage set" do
      it { is_expected.to eq(false) }
    end
  end
end

