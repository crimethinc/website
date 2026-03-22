require 'rails_helper'

RSpec.describe BooksHelper do
  describe '#thumbnail_link_to_large_image' do
    context 'with large_url' do
      subject { helper.thumbnail_link_to_large_image('http://example.com/test/small.png', '/test/larger.png') }

      it { is_expected.to eq(%(<a href="/test/larger.png"><img src="http://example.com/test/small.png" /></a>)) }
    end

    context 'without large_url' do
      subject { helper.thumbnail_link_to_large_image('http://example.com/test/small.png') }

      it { is_expected.to eq(%(<a href="http://example.com/test/large.png"><img src="http://example.com/test/small.png" /></a>)) }
    end
  end

  describe '#extension_for_ebook' do
    it 'returns epub for epub type' do
      expect(helper.extension_for_ebook(:epub)).to eq 'epub'
    end

    it 'returns mobi for mobi type' do
      expect(helper.extension_for_ebook(:mobi)).to eq 'mobi'
    end

    it 'returns pdf for other types' do
      expect(helper.extension_for_ebook(:screen)).to eq 'pdf'
    end
  end
end
