# frozen_string_literal: true

require 'rails_helper'
require 'locale_service'

describe LocaleService::Locales do
  subject { described_class.canonical(**args).canonical }

  let(:args) { { locale: 'spanish', lang_code: :es } }
  let(:unfrozen_locales) { LocaleService::Locales::LOCALES.dup }

  before do
    stub_const('LocaleService::Locales::LOCALES', unfrozen_locales)
    allow(LocaleService::Locales::LOCALES).to receive(:find).and_call_original
  end

  context 'when given an existing lang_code' do
    it { is_expected. to eq 'espanol' }

    it 'skips the long lookup and uses the precomputed hash' do
      expect(LocaleService::Locales::LOCALES).not_to have_received(:find)
    end
  end

  context 'without a lang_code' do
    subject(:service) { described_class.canonical(**args) }

    let(:args) { super().merge(lang_code: nil) }

    it 'searches across all of the locales' do
      expect(service.canonical).to eq('espanol')
      expect(LocaleService::Locales::LOCALES).to have_received(:find).once
    end
  end

  context 'when given an unknown locale' do
    subject(:service) { described_class.canonical(**args) }

    let(:args) { super().merge(locale: 'foo', lang_code: :bar) }

    it 'raises' do
      expect { service.canonical }.to raise_error ArgumentError
    end
  end
end
