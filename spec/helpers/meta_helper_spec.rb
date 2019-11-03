require 'rails_helper'

RSpec.describe MetaHelper, type: :helper do
  describe '#meta_image' do
    subject { helper.meta_image(thing) }

    context 'with a thing' do
      let(:thing) { OpenStruct.new(image: 'http://example.com/image.png', meta_image: 'http://example.com/image.png') }

      it { is_expected.to eq('http://example.com/image.png') }
    end

    context 'with a thing with no image' do
      let(:thing) { OpenStruct.new(image: nil) }

      it { is_expected.to eq('https://cloudfront.crimethinc.com/assets/share/crimethinc-site-share.png') }
    end

    context 'without a thing' do
      let(:thing) { nil }

      it { is_expected.to eq('https://cloudfront.crimethinc.com/assets/share/crimethinc-site-share.png') }
    end
  end

  describe '#page_title' do
    # context 'when viewing admin section' do
    #   let(:title) { 'title' }
    #
    #   it 'adds admin to the title in admin routes' do
    #     expect(page_title).to eq('CrimethInc. Admin : title')
    #   end
    # end
    #
    # context 'when viewing non-homepage' do
    #   let(:title) { 'title' }
    #
    #   xit 'appends the set title' do
    #     expect(page_title).to eq('CrimethInc. : title')
    #   end
    # end

    context 'when viewing homepage' do
      it 'has a default title' do
        expect(page_title).to eq('CrimethInc.')
      end
    end
  end
end
