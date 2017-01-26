require 'rails_helper'

RSpec.describe Archive, type: :model do
  describe "it sorts the articles correctly" do
    let(:first) { Article.new(published_at: DateTime.parse("2017-01-01")) }
    let(:last) { Article.new(published_at: DateTime.parse("2017-01-20")) }
    let(:articles) { [first, last] }

    subject { Archive.new(articles).first }

    it { is_expected.to eq([2017, { 1 => [first, last] }]) }
  end
end
