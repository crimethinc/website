require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #advanced_search' do
    it 'returns a result' do
      create(:article, title: 'Search Test')

      post :advanced_search, params: { advanced_search: { title: 'search' } }

      expect(assigns[:advanced_search].query).to eql('title:search')
    end
  end
end
