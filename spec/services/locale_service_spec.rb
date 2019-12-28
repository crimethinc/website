# frozen_string_literal: true

require 'rails_helper'
require 'locale_service'

describe LocaleService do
  describe '#find' do
    subject(:found_locale) { described_class.find(locale: locale, lang_code: lang_code) }

    let(:locale) { 'spanish' }
    let(:lang_code) { :es }

    shared_examples 'it returns the expected canonical name' do
      it 'returns the expected result' do
        expect(found_locale.canonical).to eq('espanol')
      end
    end

    it_behaves_like 'it returns the expected canonical name'

    context 'when locale is not found' do
      let(:lang_code) { :foo }

      it 'raises' do
        expect { found_locale.locale }.to raise_error ArgumentError
      end
    end

    context 'when searching without a lang_code' do
      let(:lang_code) { nil }

      it_behaves_like 'it returns the expected canonical name'
    end
  end
end
