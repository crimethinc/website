require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "GET #show" do
    it "renders on a tag with articles" do
      article = Article.create(title: "Test", published_at: 1.day.ago)
      article.save_tags!("Test Tag")
      tag = Tag.last

      get :show, params: {slug: tag.slug}

      expect(response).to have_http_status(:success)
    end

    it "redirects on an empty tag" do
      tag = Tag.create(name: "Test Tag")

      get :show, params: {slug: tag.slug}

      expect(response).to redirect_to(root_path)
    end
  end

end
