require 'rails_helper'

RSpec.describe PodcastsHelper do
  describe '#subscribe_links_for' do
    subject(:html) { helper.subscribe_links_for(podcast) }

    let(:podcast) { build(:podcast, **podcatchers) }
    let(:podcatchers) do
      {
        itunes_url:      'itunes-url',
        overcast_url:    'overcast-url',
        pocketcasts_url: 'pocketcasts-url'
      }
    end

    it 'generates html without line breaks between the links' do
      expect(html.count("\n")).to eq 0
    end

    it 'uses the URLs set on the podcast' do
      podcatchers
        .each_value { |url| expect(html).to include(/href="#{url}"/) }
    end

    context 'when the podcatcher url is NOT set' do
      let(:podcast) { build(:podcast) }
      let(:podcatcher_regexps) do
        podcatchers.keys.map do |k|
          id = k.to_s.gsub('_url', '')
          /<a data-podcatcher="#{id}" class="u-url" href="(.*?)">/
        end
      end

      it 'defaults to the /podcasts route' do
        podcatcher_regexps.each do |regexp|
          actual = html.match(regexp)[1]
          expect(actual).to eq podcasts_url
        end
      end
    end
  end
end
