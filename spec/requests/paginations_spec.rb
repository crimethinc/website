require "rails_helper"

RSpec.describe "Pagination Redirects", type: :request do
  describe "archives" do
    it "redirects on page 1" do
      get "/2017/01/01/page/1"

      expect(response).to redirect_to("/2017/01/01/")
    end

    it "redirects when no page number given" do
      get "/2017/01/01/page"

      expect(response).to redirect_to("/2017/01/01/")
    end
  end

  describe "categories" do
    it "redirects on page 1" do
      get "/categories/slug/page/1"

      expect(response).to redirect_to("/categories/slug/")
    end

    it "redirects when no page number given" do
      get "/categories/slug/page"

      expect(response).to redirect_to("/categories/slug/")
    end
  end

  describe "tags" do
    it "redirects on page 1" do
      get "/tags/slug/page/1"

      expect(response).to redirect_to("/tags/slug/")
    end

    it "redirects when no page number given" do
      get "/tags/slug/page"

      expect(response).to redirect_to("/tags/slug/")
    end
  end

  describe "videos" do
    it "redirects on page 1" do
      get "/videos/page/1"

      expect(response).to redirect_to("/videos/")
    end

    it "redirects when no page number given" do
      get "/videos/page"

      expect(response).to redirect_to("/videos/")
    end
  end

  describe "admin" do
    it "redirects on page 1" do
      get "/admin/videos/page/1"

      expect(response).to redirect_to("/admin/videos/")
    end

    it "redirects when no page number given" do
      get "/admin/videos/page"

      expect(response).to redirect_to("/admin/videos/")
    end
  end
end
