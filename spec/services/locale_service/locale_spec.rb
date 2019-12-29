require 'rails_helper'
require 'locale_service'

describe LocaleService::Locale do
  let(:args) { {} }

  context 'when given no locale' do
    it 'raises' do
      expect { described_class.new(**args) }.to raise_error ArgumentError
    end
  end

  context 'when given no canonical name' do
    let(:args) { super().merge(locale: 'spanish') }

    it 'raises' do
      expect { described_class.new(**args) }.to raise_error ArgumentError
    end
  end

  context 'when given a locale and a canonical name' do
    subject { described_class.new(**args).to_h }

    let(:args) { super().merge(locale: 'spanish', canonical: 'espanol') }
    let(:expected_hash) { { locale: 'spanish', lang_code: nil, canonical: 'espanol' } }

    it { is_expected.to eq expected_hash }
  end
end
