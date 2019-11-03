require 'rails_helper'

RSpec.describe PageTitle, type: :model do
  describe '.with' do
    context 'with no args' do
      it 'falls back to default' do
        title = described_class.with

        expect(title).to eq 'CrimethInc.'
      end
    end

    context 'with text' do
      it 'appends text with site name, separated by a colon' do
        title = described_class.with text: 'page title'

        expect(title).to eq 'CrimethInc. : page title'
      end
    end

    context 'with path' do
      it 'builds colon separated title from path pieces' do
        title = described_class.with path: 'admin/books/new'

        expect(title).to eq 'CrimethInc. : Admin : Books : New'
      end
    end
  end
end
