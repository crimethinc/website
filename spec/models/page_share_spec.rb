require 'rails_helper'

RSpec.describe PageShare do
  let(:page_share) do
    described_class.new(
      url:       'https://crimethinc.com/articles/test',
      title:     'Test Article',
      subtitle:  'A Subtitle',
      content:   'Some content here',
      image_url: 'https://crimethinc.com/image.jpg'
    )
  end

  describe '#name' do
    it 'combines title and subtitle' do
      expect(page_share.name).to eq 'Test Article : A Subtitle'
    end
  end

  describe '#share_url_for' do
    it 'returns a twitter share url' do
      url = page_share.share_url_for(:twitter)

      expect(url).to start_with 'https://twitter.com/intent/tweet'
      expect(url).to include 'via=crimethinc'
      expect(url).to include URI.encode_www_form_component('https://crimethinc.com/articles/test')
    end

    it 'returns a facebook share url' do
      url = page_share.share_url_for(:facebook)

      expect(url).to start_with 'https://www.facebook.com/dialog/feed'
      expect(url).to include URI.encode_www_form_component('https://crimethinc.com/articles/test')
      expect(url).to include URI.encode_www_form_component('https://crimethinc.com/image.jpg')
    end

    it 'returns a tumblr share url' do
      url = page_share.share_url_for(:tumblr)

      expect(url).to start_with 'http://tumblr.com/widgets/share/tool'
      expect(url).to include URI.encode_www_form_component('https://crimethinc.com/articles/test')
    end

    it 'returns an email share url' do
      url = page_share.share_url_for(:email)

      expect(url).to start_with 'mailto:'
      expect(url).to include 'subject='
      expect(url).to include 'body='
    end
  end
end
