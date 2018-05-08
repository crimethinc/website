require "rails_helper"

RSpec.describe BooksHelper, type: :helper do
  describe "#thumbnail_link_to_large_image" do
    context "with large_url" do
      subject { helper.thumbnail_link_to_large_image("http://example.com/test/small.png", "/test/larger.png") }

      it { is_expected.to eq(%{<a href="/test/larger.png"><img src="http://example.com/test/small.png" /></a>}) }
    end

    context "without large_url" do
      subject { helper.thumbnail_link_to_large_image("http://example.com/test/small.png") }

      it { is_expected.to eq(%{<a href="http://example.com/test/large.png"><img src="http://example.com/test/small.png" /></a>}) }
    end
  end
end
