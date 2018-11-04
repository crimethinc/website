require 'rails_helper'

RSpec.describe Post, type: :model do
  %w[draft published].each do |status_name|
    describe "#{status_name}?" do
      subject { post.send("#{status_name}?") }

      context "with status of #{status_name}" do
        let(:post) { Page.new(publication_status: status_name) }

        it { is_expected.to eq(true) }
      end
    end
  end

  describe 'dated?' do
    subject { post.dated? }

    context 'with published_at' do
      let(:post) { Page.new(published_at: Time.now.utc) }

      it { is_expected.to be(true) }
    end

    context 'without published_at' do
      let(:post) { Page.new }

      it { is_expected.to be(false) }
    end
  end

  describe '#meta_description' do
    subject { post.meta_description.strip }

    context 'with summary' do
      let(:post) { Page.new(summary: 'summary') }

      it { is_expected.to eq('summary') }
    end

    context 'without summary' do
      let(:post) { Page.new(content: '*content*') }

      it { is_expected.to eq('content') }
    end
  end

  describe '#generated_draft_code' do
    subject { post.draft_code }

    let(:post) { Page.create(title: 'test') }

    it { is_expected.to be_present }
  end
end
