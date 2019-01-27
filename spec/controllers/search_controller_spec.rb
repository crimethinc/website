require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #advanced_search' do
    let!(:article) { create(:article, title: 'Search Test') }

    it 'returns a result' do
      post :advanced_search, params: {advanced_search: {title: 'search'}}

      expect(assigns[:advanced_search].query).to eql('title:search')
    end
  end
end