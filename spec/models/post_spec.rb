require 'rails_helper'

RSpec.describe Post do
  %w[draft published].each do |status_name|
    describe "#{status_name}?" do
      subject { post.send(:"#{status_name}?") }

      context "with status of #{status_name}" do
        let(:post) { Page.new(publication_status: status_name) }

        it { is_expected.to be(true) }
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

  describe 'Publishable.publication_statuses_for' do
    it 'returns all statuses for publishers' do
      publisher = build(:user, role: 'publisher')

      expect(Publishable.publication_statuses_for(user: publisher)).to eq %i[draft published]
    end

    it 'excludes published for non-publishers' do
      author = build(:user, role: 'author')

      expect(Publishable.publication_statuses_for(user: author)).to eq %i[draft]
    end
  end

  describe '#meta_image' do
    it 'falls back to default when image is blank' do
      post = Page.new(title: 'test')

      expect(post.meta_image).to eq I18n.t('head.meta_image_url')
    end
  end

  describe '#generated_draft_code' do
    subject { post.draft_code }

    let(:post) { Page.create(title: 'test') }

    it { is_expected.to be_present }
  end
end
