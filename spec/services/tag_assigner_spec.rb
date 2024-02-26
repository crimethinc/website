require 'rails_helper'

describe TagAssigner do
  describe 'parse_glob' do
    subject { described_class.parse_glob(glob) }

    it 'can parse a single tag name' do
      glob = 'foo'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq ['foo']
    end

    it 'can parse a comma separated list of tags' do
      glob = 'foo, bar, baz'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq %w[foo bar baz]
    end

    it 'drops blank tags' do
      glob = 'foo,, bar'
      expect(described_class.parse_glob(glob).tags.map(&:name)).to eq %w[foo bar]
    end
  end

  describe 'assign_tags_to!' do
    subject(:tag_assigner) { described_class.new(tag_1, tag_2, tag_3) }

    let(:tag_1) { double }
    let(:tag_2) { double }
    let(:tag_3) { double }
    let(:taggable) { double }

    it 'assigns tags which have not been assigned' do
      allow(tag_1).to receive(:assigned_to?).with(taggable).and_return false
      allow(tag_2).to receive(:assigned_to?).with(taggable).and_return true
      allow(tag_3).to receive(:assigned_to?).with(taggable).and_return false

      expect(tag_1).to receive(:assign_to!).with(taggable)
      expect(tag_2).not_to receive(:assign_to!).with(taggable)
      expect(tag_3).to receive(:assign_to!).with(taggable)

      tag_assigner.assign_tags_to!(taggable)
    end
  end
end
