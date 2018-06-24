require 'rails_helper'

RSpec.describe ArticlesHelper, type: :helper do
  describe '#article_tag' do
    subject { helper.article_tag(article) { 'Test Text' }.to_s }

    context 'without an image' do
      let(:article) { Article.new(id: 1, slug: 'slug') }

      it { is_expected.to match(%r{\A<article [^>]+>.*<\/article>\z}) }
      it { is_expected.to match('h-entry') }
      it { is_expected.to match('article-with-no-header-image') }
      it { is_expected.to match(%(data-id="1")) }
      it { is_expected.to match(/data-published-at="\d+"/) }
      it { is_expected.to match('Test Text') }

      it { is_expected.not_to match('data-listen') }
    end

    context 'with an image' do
      let(:article) { Article.new(id: 1, slug: 'slug', image: 'http://example.com') }

      it { is_expected.to match(%r{\A<article [^>]+>.*<\/article>\z}) }
      it { is_expected.to match('h-entry') }
      it { is_expected.to match(%(data-id="1")) }
      it { is_expected.to match(/data-published-at="\d+"/) }
      it { is_expected.to match('Test Text') }

      it { is_expected.not_to match('data-listen') }
      it { is_expected.not_to match('article-with-no-header-image') }
    end

    context 'with collection posts' do
      let(:article) { Article.new(id: 1, slug: 'slug') }

      before { expect(article).to receive(:collection_posts) { OpenStruct.new(recent: [Article.new]) } }

      it { is_expected.to match(%r{\A<article [^>]+>.*<\/article>\z}) }
      it { is_expected.to match('h-entry') }
      it { is_expected.to match('article-with-no-header-image') }
      it { is_expected.to match(%(data-id="1")) }
      it { is_expected.to match(/data-published-at="\d+"/) }
      it { is_expected.to match('Test Text') }
      it { is_expected.to match('data-listen') }
    end
  end

  describe '#display_date' do
    context 'with a datetime' do
      subject { helper.display_date(date) }

      let(:date) { Date.parse('2017-01-01') }

      it { is_expected.to eq('2017-01-01') }
    end

    context 'without a datetime' do
      subject { helper.display_date(nil) }

      it { is_expected.to be_nil }
    end
  end

  describe '#display_time' do
    context 'with a datetime' do
      subject { helper.display_time(date) }

      let(:date) { Date.parse('2017-01-01') }

      it { is_expected.to eq('12:00&nbsp;+0000') }
    end

    context 'without a datetime' do
      subject { helper.display_date(nil) }

      it { is_expected.to be_nil }
    end
  end

  # <a rel="archives" class="year" href="/2017">2017</a>-<a rel="archives" class="month" href="/2017/01">01</a>-<a rel="archives" class="day" href="/2017/01/01">01</a>
  describe '#link_to_dates' do
    subject { helper.link_to_dates(year: 2017, month: 1, day: 1) }

    it { is_expected.to match(%(<a rel="archives" class="year" href="/2017">2017</a>)) }
    it { is_expected.to match(%(<a rel="archives" class="month" href="/2017/01">01</a>)) }
    it { is_expected.to match(%(<a rel="archives" class="day" href="/2017/01/01">01</a>)) }
  end
end
