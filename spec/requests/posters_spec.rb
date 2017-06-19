require 'rails_helper'

RSpec.describe "Posters", type: :request do
  describe "GET /posters" do
    it "works! (now write some real specs)" do
      get posters_path
      expect(response).to have_http_status(200)
    end
  end
end
