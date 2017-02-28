require "rails_helper"

RSpec.describe Redirect, type: :model do
  describe "#name" do
    let(:redirect) { Redirect.new(source_path: "/source", target_path: "/target") }

    subject { redirect.name }

    it { is_expected.to eq("/source to /target") }
  end

  describe "#add_leading_slash" do
    before { redirect.add_leading_slash }

    subject { redirect }

    context "with absolute urls" do
      let(:redirect) { Redirect.new(source_path: "http://example.com/source", target_path: "http://example.com/target") }

      specify { expect(subject.source_path).to eq("http://example.com/source") }
      specify { expect(subject.target_path).to eq("http://example.com/target") }
    end

    context "with relative urls" do
      let(:redirect) { Redirect.new(source_path: "source", target_path: "target") }

      specify { expect(subject.source_path).to eq("/source") }
      specify { expect(subject.target_path).to eq("/target") }
    end
  end

  describe "#strip_leading_domain" do
    before { redirect.strip_leading_domain }

    subject { redirect.target_path }

    context "with leading domain" do
      let(:redirect) { Redirect.new(source_path: "source", target_path: "http://crimethinc.com/?query=true") }

      it { is_expected.to eq("/?query=true") }
    end
  end

  describe "#delete_duplicates" do
    let(:attributes) { { source_path: "source", target_path: "target" } }

    before { 2.times { Redirect.create(attributes) } }

    specify { expect(Redirect.count).to eq(1) }
  end

  describe "#noncircular_redirect" do
    before { redirect.valid? }

    let(:redirect) { Redirect.new(source_path: "source", target_path: "source") }

    subject { redirect.errors[:target_path] }

    it { is_expected.to include("redirects to itself") }
  end
end
