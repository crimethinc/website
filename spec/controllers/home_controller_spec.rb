require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    it 'responds successfully' do
      get 'index'

      expect(response).to be_successful
    end

    it 'redirect to atom feed when request with atom format' do
      get 'index', format: :atom

      expect(response).to redirect_to(feed_path)
      expect(response.content_type).to start_with 'application/atom'
    end

    it 'redirect to atom feed when request with xml format' do
      get 'index', format: :xml

      expect(response).to redirect_to(feed_path)
      expect(response.content_type).to start_with 'application/xml'
    end

    it 'redirect to json feed when request with json format' do
      get 'index', format: :json

      expect(response).to redirect_to(json_feed_path)
      expect(response.content_type).to start_with 'application/json'
    end

    it 'returns 404 for invalid format' do
      get 'index', format: :zip

      expect(response).to have_http_status(:not_found)
    end
  end
end
