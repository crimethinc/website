require 'rails_helper'

RSpec.describe AlphabetHelper do
  describe '#alphabet' do
    it 'returns a-z as an array' do
      expect(helper.alphabet).to eq ('a'..'z').to_a
    end
  end

  describe '#link_to_alphabet' do
    it 'returns links for each letter' do
      result = helper.link_to_alphabet

      expect(result).to include('A')
      expect(result).to include('Z')
      expect(result).to include('#a')
    end
  end
end
