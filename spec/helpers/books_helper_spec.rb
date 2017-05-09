require "rails_helper"

RSpec.describe BooksHelper, type: :helper do
  describe "#thumbnail_link_to_large_image" do
    context "with large_url" do
      subject { helper.thumbnail_link_to_large_image("test/small.png", "/test/larger.png") }

      it { is_expected.to eq(%{<a href="/test/larger.png"><img src="/images/test/small.png" alt="Small" /></a>}) }
    end

    context "without large_url" do
      subject { helper.thumbnail_link_to_large_image("test/small.png") }

      it { is_expected.to eq(%{<a href="test/large.png"><img src="/images/test/small.png" alt="Small" /></a>}) }
    end
  end
end
