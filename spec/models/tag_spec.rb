require "rails_helper"

describe Tag do
  subject { Tag.new(name: 'test') }

  describe 'assigned_to?' do
    let(:page) { Page.create(title: 'about') }
    context 'assigned to page' do
      before do
        subject.assign_to!(page)
      end

      it 'returns true' do
        expect(subject).to be_assigned_to(page)
      end
    end

    context 'not assigned ts page' do
      it 'returns false' do
        expect(subject).not_to be_assigned_to(page)
      end
    end
  end

  describe 'assign_to!' do
    let(:article) { Article.new(title: 'foobar') }
    let(:page) { Page.new(title: 'about') }

    it 'assigns the tag to articles' do
      subject.assign_to!(article)
      expect(subject.articles).to eq [article]
    end

    it 'assigns the tag to pages' do
      subject.assign_to!(page)
      expect(subject.pages).to eq [page]
    end
  end
end
