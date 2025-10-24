require 'rails_helper'

RSpec.describe Episode do
  describe '#name' do
    subject { episode.name }

    context 'with a subtitle' do
      let(:episode) { described_class.new(title: 'title', subtitle: 'subtitle') }

      it { is_expected.to eq('title : subtitle') }
    end

    context 'without a subtitle' do
      let(:episode) { described_class.new(title: 'title') }

      it { is_expected.to eq('title') }
    end
  end

  describe '#path' do
    subject { episode.path }

    let(:podcast) { Podcast.create(slug: 'a-nice-podcast') }
    let(:episode) { described_class.create(id: 1, slug: 'test-slug', podcast: podcast, publication_status: :published) }

    it { is_expected.to eq('/podcasts/a-nice-podcast/episodes/1') }
  end

  describe '#duration_string' do
    subject { episode.duration_string }

    let(:episode) { described_class.new(duration: 60) }

    it { is_expected.to eq('01:00:00') }
  end

  describe '#meta_description' do
    subject { episode.meta_description }

    context 'with subtitle' do
      let(:episode) { described_class.new(subtitle: 'subtitle') }

      it { is_expected.to eq('subtitle') }
    end

    context 'without subtitle' do
      let(:episode) { described_class.new(content: 'x' * 250) }

      it { is_expected.to eq("#{'x' * 197}...") }
    end
  end
end
