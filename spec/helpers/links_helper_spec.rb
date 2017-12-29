require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  describe "#social_link_classes" do
    subject { helper.social_link_classes(url: "http://example.com", name: "example") }

    it { is_expected.to eq("link-name-example link-domain-example") }
  end
end
