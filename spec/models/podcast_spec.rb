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

  describe '#slug' do
    subject { podcast.slug }

    context 'with slug' do
      let(:podcast) { described_class.new(slug: 'slug') }

      it { is_expected.to eq('slug') }
    end

    context 'without slug' do
      let(:podcast) { described_class.new(slug: nil) }

      it { is_expected.to be_nil }
    end
  end

  describe 'validations' do

    
    it 'validates the presence of a slug' do
      valid_podcast   = build(:podcast, slug: 'anarchy')

      expect(valid_podcast).to be_valid
    end

    it 'validates lack of presence of a slug' do
      invalid_podcast = build(:podcast, slug: nil)

      expect(invalid_podcast).not_to be_valid
    end

    it 'validates uniqueness of slug' do
      valid_podcast  = build(:podcast, slug: 'anarchy')
      invalid_podcast = build(:podcast, slug: 'anarchy')
      
      valid_podcast.save!
      expect(valid_podcast).to be_valid
      expect { invalid_podcast.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Slug has already been taken')
    end
  end
end
