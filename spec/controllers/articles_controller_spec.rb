require 'rails_helper'

RSpec.describe ArticlesController do
  describe 'GET #index' do
    context 'when params[:page] is a number larger than Postgres can store as bigint' do
      let(:huge_page) { '569480344293394003561863877600713420' }

      it 'does not raise a database range error' do
        expect { get :index, params: { page: huge_page } }.not_to raise_error
      end

      it 'redirects to a clamped, sane page number' do
        get :index, params: { page: huge_page }

        expect(response).to be_redirect
        expect(response.location).not_to include huge_page
      end
    end
  end
end
