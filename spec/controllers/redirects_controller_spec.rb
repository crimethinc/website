require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe 'GET show' do
    it 'redirects temporarily when present' do
      Redirect.create(source_path: '/anonymous', target_path: 'http://example.com', temporary: true)

      get :show

      expect(response.status).to have_http_status(:moved_permanently)
    end

    it 'redirects permanently when present' do
      Redirect.create(source_path: '/anonymous', target_path: 'http://example.com', temporary: false)

      get :show

      expect(response.status).to have_http_status(:found)
    end
  end
end
