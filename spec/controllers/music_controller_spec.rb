require 'rails_helper'

RSpec.describe MusicController do
  describe 'GET #index' do
    it 'redirects to the CrimethInc. Bandcamp page without raising' do
      expect { get :index }.not_to raise_error

      expect(response).to redirect_to('https://crimethinc.bandcamp.com')
    end
  end
end
