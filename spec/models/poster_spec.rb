require 'rails_helper'

RSpec.describe Poster, type: :model do
    describe "#published?" do
    subject { book.published? }

    let(:status) { Status.new(name: "published") }
    let(:poster) { Book.new(title: "Contradictionary", status: status) }

    it { is_expected.to eq(true)}
  end
end
