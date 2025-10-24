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
    subject(:tag_assigner) { described_class.new(first_tag, second_tag, third_tag) }

    let(:first_tag) { double }
    let(:second_tag) { double }
    let(:third_tag) { double }
    let(:taggable) { double }

    it 'assigns tags which have not been assigned' do
      allow(first_tag).to receive(:assigned_to?).with(taggable).and_return false
      allow(second_tag).to receive(:assigned_to?).with(taggable).and_return true
      allow(third_tag).to receive(:assigned_to?).with(taggable).and_return false

      allow(first_tag).to receive(:assign_to!)
      allow(second_tag).to receive(:assign_to!)
      allow(third_tag).to receive(:assign_to!)

      tag_assigner.assign_tags_to!(taggable)

      expect(first_tag).to have_received(:assign_to!).with(taggable)
      expect(second_tag).not_to have_received(:assign_to!).with(taggable)
      expect(third_tag).to have_received(:assign_to!).with(taggable)
    end
  end
end
