require "rails_helper"

RSpec.describe Subscriber, type: :model do
  describe "#name" do
    let(:subscriber) { Subscriber.new(email: "email@example.com") }

    subject { subscriber.name }

    it { is_expected.to eq("email@example.com") }
  end

  describe "#clean_email" do
    let(:subscriber) { Subscriber.create(email: "    eMAIl@example.com     ") }

    subject { subscriber.email }

    it { is_expected.to eq("email@example.com") }
  end
end
