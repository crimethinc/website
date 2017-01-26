require "rails_helper"

RSpec.describe VideosController, type: :controller do
  describe "GET index" do
    it "renders the videos" do
      get :index

      expect(response).to have_http_status(200)
    end
  end

  describe "GET show" do
    it "renders the video" do
      video = Video.create(slug: "slug")

      get :show, params: { slug: video.slug }

      expect(response).to have_http_status(200)
    end

    it "responds with 404 if it can't find the video" do
      expect { get :show, params: { slug: "slug" } }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
