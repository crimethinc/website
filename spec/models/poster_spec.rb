require 'rails_helper'

RSpec.describe Poster, type: :model do
    describe "#published?" do
    subject { poster.published? }

    let(:status) { Status.new(name: "published") }
    let(:poster) { Poster.new(title: "Poster", status: status) }

    it { is_expected.to eq(true)}
  end
end
