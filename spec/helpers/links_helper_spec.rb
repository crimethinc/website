require 'rails_helper'

RSpec.describe LinksHelper do
  describe '#social_link_classes' do
    subject { helper.social_link_classes(url: 'http://example.com', name: 'example') }

    it { is_expected.to eq('link-name-example link-domain-example') }
  end

  describe '#social_links_by_domain' do
    it 'returns an array of social link hashes' do
      links = helper.social_links_by_domain

      expect(links).to be_an Array
      expect(links.first.keys.first).to eq :Mastodon
    end
  end
end
