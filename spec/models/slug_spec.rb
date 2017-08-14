require "rails_helper"

describe Slug do
  let(:model) { Page.new(title: "test") }

  describe "generating a new slug when slug exists" do
    before { Page.create!(title: "test") }

    subject { model.generate_slug }

    it { is_expected.to eq("test-1") }
  end
end

