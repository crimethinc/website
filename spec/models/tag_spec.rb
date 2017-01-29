require 'rails_helper'

describe Tag do
  describe 'assign_to!' do
    subject { Tag.new(name: 'test') }
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
