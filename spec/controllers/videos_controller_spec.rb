require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET index' do
    it 'renders the videos' do
      get :index

      expect(response).to have_http_status(200)
    end
  end

  describe 'GET show' do
    it 'renders the video' do
      video = Video.create(slug: 'slug')

      get :show, params: { slug: video.slug }

      expect(response).to have_http_status(200)
    end

    it 'redirects to root if it can’t find the video' do
      get :show, params: { slug: 'slug' }

      expect(response).to redirect_to([:videos])

    end
  end
end
