require 'rails_helper'

RSpec.describe Page, type: :model do
  describe '#path' do
    subject { page.path }

    context 'when published' do
      let(:status) { Status.new(name: 'published') }
      let(:page) { Page.new(slug: 'slug', status: status) }

      it { is_expected.to eq('/slug') }
    end

    context 'when unpublished' do
      let(:status) { Status.new }
      let(:page) { Page.new(draft_code: 'draft-code', status: status) }

      it { is_expected.to eq('/drafts/pages/draft-code') }
    end
  end

  describe '#content_rendered' do
    let(:page) { Page.new(content: 'content') }

    subject { page.content_rendered.strip }

    it { is_expected.to eq('<p>content</p>') }
  end
end
