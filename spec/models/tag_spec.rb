require 'rails_helper'

describe Tag do
  subject(:tag) { described_class.new(name: 'test') }

  describe 'assigned_to?' do
    let(:page) { Page.create(title: 'about') }

    context 'when assigned to a page' do
      before do
        tag.assign_to!(page)
      end

      it 'returns true' do
        expect(tag).to be_assigned_to(page)
      end
    end

    context 'when not assigned to a page' do
      it 'returns false' do
        expect(tag).not_to be_assigned_to(page)
      end
    end
  end

  describe 'assign_to!' do
    let(:published_at) { Date.current }
    let(:article) { Article.new(title: 'foobar', short_path: SecureRandom.hex, publication_status: 'published', published_at: published_at) }
    let(:page) { Page.new(title: 'about') }

    it 'assigns the tag to articles' do
      tag.assign_to!(article)
      expect(tag.articles).to eq [article]
    end

    it 'assigns the tag to pages' do
      tag.assign_to!(page)
      expect(tag.pages).to eq [page]
    end
  end
end
