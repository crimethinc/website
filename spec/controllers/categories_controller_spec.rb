require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    it "renders on a category with articles" do
      article = Article.create(title: "Test", published_at: 1.day.ago)
      article.save_categories!("Test Category")
      category = Category.last

      get :show, params: {slug: category.slug}

      expect(response).to have_http_status(:success)
    end

    it "redirects on an empty category" do
      category = Category.create(name: "Test Category")

      get :show, params: {slug: category.slug}

      expect(response).to redirect_to(root_path)
    end
  end

end
