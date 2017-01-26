require 'rails_helper'

describe TagAssigner do
  let(:name1) { 'foo' }
  let(:name2) { 'bar' }
  let(:tag1) { Tag.new(name: name1) }
  let(:tag2) { Tag.new(name: name2) }
  let(:article) { Article.new(title: 'test article') }
  let(:page) { Page.new(title: 'test page') }
  subject { described_class.new(name1, name2) }

  it 'initializes tags for each name passed to it' do
    expect(subject.tags.map(&:attributes)).to eq [tag1, tag2].map(&:attributes)
  end

  it 'can parse a comma separated list of tags' do
    subject = described_class.parse_glob("#{name1}, #{name2}")
    expect(subject.tags.map(&:attributes)).to eq [tag1, tag2].map(&:attributes)
  end

  it 'can tag articles' do
    subject.assign_tags_to!(article)
    expect(article.tags.map(&:name)).to match_array [tag1, tag2].map(&:name)
  end

  it 'can tag pages' do
    subject.assign_tags_to!(page)
    expect(page.tags.map(&:name)).to match_array [tag1, tag2].map(&:name)
  end
end
