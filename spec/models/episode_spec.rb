require "rails_helper"

RSpec.describe Episode, type: :model do
  describe "#name" do
    subject { episode.name }

    context "with a subtitle" do
      let(:episode) { Episode.new(title: "title", subtitle: "subtitle") }

      it { is_expected.to eq("title : subtitle") }
    end

    context "without a subtitle" do
      let(:episode) { Episode.new(title: "title") }

      it { is_expected.to eq("title") }
    end
  end

  describe "#path" do
    let(:episode) { Episode.new(id: 1, slug: "test-slug") }

    subject { episode.path }

    it { is_expected.to eq("/podcast/test-slug")}
  end

  describe "#duration_string" do
    let(:episode) { Episode.new(duration: 60) }

    subject { episode.duration_string }

    it { is_expected.to eq("01:00:00") }
  end

  describe "#meta_description" do
    subject { episode.meta_description }

    context "with subtitle" do
      let(:episode) { Episode.new(subtitle: "subtitle") }

      it { is_expected.to eq("subtitle") }
    end

    context "without subtitle" do
      let(:episode) { Episode.new(content: "x" * 250) }

      it { is_expected.to eq("x" * 197 + "...") }
    end
  end
end
