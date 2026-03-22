require 'rails_helper'

RSpec.describe EmbedsHelper do
  describe '#embed_link' do
    it 'strips the protocol and trailing slash from display text' do
      result = helper.embed_link('https://example.com/')

      expect(result).to include('example.com')
      expect(result).to include('href="https://example.com/"')
      expect(result).not_to include('>https://')
    end
  end
end
