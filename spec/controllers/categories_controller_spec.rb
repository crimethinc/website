require "rails_helper"

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    let(:status)  { Status.new(name: "published") }
    it "redirects with a normalized slug" do
      slug = "underscored_slug"
      normalized_slug = slug.sub("_", "-")

      get :show, params: {slug: slug}

      expect(response).to redirect_to(category_path(normalized_slug))
    end

    it "renders on a category with articles" do
      category = Category.create(name: "Test Category")
      article = Article.create(title: "Test", published_at: 1.day.ago, category_ids: [category.id], short_path: SecureRandom.hex, status: Status.last)
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
    let(:status)  { Status.new(name: "published") }
    it "renders on a category with articles" do
      category = Category.create(name: "Test Category")
      article = Article.create(title: "Test", published_at: 1.day.ago, category_ids: [category.id], short_path: SecureRandom.hex, status: Status.last)
      category = Category.last

      get :feed, params: {slug: category.slug}

      expect(response).to have_http_status(:success)
    end
  end

end
