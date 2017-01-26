require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  describe "#social_link_classes" do
    let(:link) { Link.new(url: "http://example.com", name: "example") }

    subject { helper.social_link_classes(link) }

    it { is_expected.to eq("link-name-example link-domain-example") }
  end
end
