require "rails_helper"

RSpec.describe BooksHelper, type: :helper do
  describe "#thumbnail_link_to_large_image" do
    context "with large_url" do
      subject { helper.thumbnail_link_to_large_image("small.png", "larger.png") }

      it { is_expected.to eq(%{<a href="larger.png"><img src="/images/small.png" alt="Small" /></a>}) }
    end

    context "without large_url" do
      subject { helper.thumbnail_link_to_large_image("small.png") }

      it { is_expected.to eq(%{<a href="large.png"><img src="/images/small.png" alt="Small" /></a>}) }
    end
  end
end
