require 'rails_helper'

RSpec.describe Page, type: :model do
  describe '#path' do
    subject { page.path }

    context 'when published' do
      let(:page) { Page.new(slug: 'slug', publication_status: 'published') }

      it { is_expected.to eq('/slug') }
    end

    context 'when unpublished' do
      let(:page) { Page.new(draft_code: 'draft-code', publication_status: 'draft') }

      it { is_expected.to eq('/drafts/pages/draft-code') }
    end
  end

  describe '#content_rendered' do
    subject { page.content_rendered.strip }

    let(:page) { Page.new(content: 'content') }

    it { is_expected.to eq('<p>content</p>') }
  end
end
