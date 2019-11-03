require 'rails_helper'

RSpec.describe PageTitle, type: :model do
  describe '.with' do
    context 'with no args' do
      it 'falls back to default' do
        title = described_class.with

        expect(title).to eq 'CrimethInc.'
      end
    end
  end
end
