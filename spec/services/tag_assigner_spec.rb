require "rails_helper"

describe TagAssigner do
  describe 'parse_glob' do
    subject { described_class.parse_glob(glob) }

    it 'can parse a single tag name' do
      glob = 'foo'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq ['foo']
    end

    it 'can parse a comma separated list of tags' do
      glob = 'foo, bar, baz'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq %w(foo bar baz)
    end

    it 'will drop blank tags' do
      glob = 'foo,, bar'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq %w(foo bar)
    end
  end

  describe 'assign_tags_to!' do
    subject { described_class.new(tag1, tag2, tag3) }
    let(:tag1) { double }
    let(:tag2) { double }
    let(:tag3) { double }
    let(:taggable) { double }

    it 'assigns tags which have not been assigned' do
      allow(tag1).to receive(:assigned_to?).with(taggable) { false }
      allow(tag2).to receive(:assigned_to?).with(taggable) { true }
      allow(tag3).to receive(:assigned_to?).with(taggable) { false }

      expect(tag1).to receive(:assign_to!).with(taggable)
      expect(tag2).not_to receive(:assign_to!).with(taggable)
      expect(tag3).to receive(:assign_to!).with(taggable)
      subject.assign_tags_to!(taggable)
    end
  end
end
