require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #show' do
    let(:category) { create(:category, name: 'Test Category') }

    it 'redirects with a normalized slug' do
      slug = 'underscored_slug'
      normalized_slug = slug.sub('_', '-')

      get :show, params: { slug: slug }

      expect(response).to redirect_to(category_path(normalized_slug))
    end

    it 'renders on a category with articles' do
      create(:article, title: 'Test', published_at: 1.day.ago, category_ids: [category.id], publication_status: 'published')

      get :show, params: { slug: category.slug }

      expect(response).to be_successful
    end

    it 'redirects on an empty category' do
      get :show, params: { slug: category.slug }

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #feed' do
    let(:category) { create(:category, name: 'Test Category') }

    it 'renders on a category with articles' do
      create(:article, title: 'Test', published_at: 1.day.ago, category_ids: [category.id], publication_status: 'published')

      get :feed, params: { slug: category.slug }

      expect(response).to be_successful
    end
  end
end
