require 'rails_helper'

RSpec.describe Contributor, type: :model do
  describe "#bio_rendered" do
    let(:contributor) { Contributor.new(bio: "biography") }

    subject { contributor.bio_rendered.strip }

    it { is_expected.to eq("<p>biography</p>")}
  end
end
