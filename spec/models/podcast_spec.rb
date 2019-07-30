require 'rails_helper'

RSpec.describe Podcast, type: :model do
  describe '#name' do
    subject { podcast.name }

    context 'with a subtitle' do
      let(:podcast) { described_class.new(title: 'title', subtitle: 'subtitle') }

      it { is_expected.to eq('title : subtitle') }
    end

    context 'without a subtitle' do
      let(:podcast) { described_class.new(title: 'title') }

      it { is_expected.to eq('title') }
    end
  end

  describe '#path' do
    subject { described_class.new(slug: 'a-nice-podcast').path }

    it { is_expected.to eq('/podcasts/a-nice-podcast') }
  end

  describe '#meta_description' do
    subject { podcast.meta_description }

    context 'with subtitle' do
      let(:podcast) { described_class.new(subtitle: 'subtitle') }

      it { is_expected.to eq('subtitle') }
    end

    context 'without subtitle' do
      let(:podcast) { described_class.new(content: 'x' * 250) }

      it { is_expected.to eq('x' * 197 + '...') }
    end
  end
end
