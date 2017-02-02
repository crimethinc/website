require "rails_helper"

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    it "redirects with a normalized slug" do
      slug = "underscored_slug"
      normalized_slug = slug.sub("_", "-")

      get :show, params: {slug: slug}

      expect(response).to redirect_to(category_path(normalized_slug))
    end

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

  describe "GET #feed" do
    it "renders on a category with articles" do
      article = Article.create(title: "Test", published_at: 1.day.ago)
      article.save_categories!("Test Category")
      category = Category.last

      get :feed, params: {slug: category.slug}

      expect(response).to have_http_status(:success)
    end
  end

end
