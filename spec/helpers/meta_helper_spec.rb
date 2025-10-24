require 'rails_helper'

RSpec.describe MetaHelper do
  describe '#meta_image' do
    subject { helper.meta_image(thing) }

    context 'with a thing' do
      let(:thing) { instance_double(Article, image: 'http://example.com/image.png', meta_image: 'http://example.com/image.png') }

      it { is_expected.to eq('http://example.com/image.png') }
    end

    context 'with a thing with no image' do
      let(:thing) { instance_double(Article, image: nil) }

      it { is_expected.to eq('https://cdn.crimethinc.com/assets/share/crimethinc-site-share.png') }
    end

    context 'without a thing' do
      let(:thing) { nil }

      it { is_expected.to eq('https://cdn.crimethinc.com/assets/share/crimethinc-site-share.png') }
    end
  end
end
