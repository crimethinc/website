require "rails_helper"

describe Name do

  describe "#name" do
    subject { model.name }

    context "with a subtitle" do
      let(:model) { Page.new(title: "title", subtitle: "subtitle") }

      it { is_expected.to eq("title : subtitle") }
    end

    context "without a subtitle" do
      let(:model) { Page.new(title: "title") }

      it { is_expected.to eq("title") }
    end
  end
end

