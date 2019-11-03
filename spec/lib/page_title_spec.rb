require 'rails_helper'

RSpec.describe PageTitle, type: :model do
  describe '#content' do
    context 'with no args' do
      let(:title) { described_class.new.content }

      it 'falls back to default' do
        expect(title).to eq 'CrimethInc.'
      end
    end

    context 'with text' do
      let(:title) { described_class.new(text: 'page title').content }

      it 'appends text with site name, separated by a colon' do
        expect(title).to eq 'CrimethInc. : page title'
      end
    end

    context 'with path' do
      let(:title) { described_class.new(path: 'admin/books/new').content }

      it 'builds colon separated title from path pieces' do
        expect(title).to eq 'CrimethInc. : Admin : Books : New'
      end
    end

    context 'with HTML in text' do
      let(:title) { described_class.new(text: 'This is <b>BOLD</b> text').content }

      it 'strips out HTML tags' do
        expect(title).to eq 'CrimethInc. : This is BOLD text'
      end
    end
  end
end
