require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  context 'unauthorized' do
    it 'redirects on index' do
      get :index

      expect(response).to have_http_status(:found)
    end

    it 'redirects on new' do
      get :new

      expect(response).to have_http_status(:found)
    end

    it 'redirects on create' do
      post :create, params: { category: { name: 'test' } }

      expect(response).to have_http_status(:found)
    end

    it 'redirects on show' do
      category = create(:category)
      get :show, params: { id: category.id }

      expect(response).to have_http_status(:found)
    end

    it 'redirects on edit' do
      category = create(:category)
      get :edit, params: { id: category.id }

      expect(response).to have_http_status(:found)
    end

    it 'redirects on update' do
      category = create(:category)
      patch :update, params: { id: category.id, category: { name: 'test' } }

      expect(response).to have_http_status(:found)
    end

    it 'redirects on destroy' do
      category = create(:category)
      delete :destroy, params: { id: category.id }

      expect(response).to have_http_status(:found)
    end
  end

  context 'authorized' do
    let(:user) { create(:user) }
    before { session[:user_id] = user.id }

    describe 'GET #index' do
      it 'renders index' do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET #show' do
      it 'renders show' do
        category = create(:category)
        get :show, params: { id: category.id }

        expect(response).to have_http_status(:found)
        expect(assigns[:category]).to eq(category)
      end
    end

    describe 'POST #create' do
      it 'creates a category' do
        post :create, params: { category: attributes_for(:category) }

        expect(response).to have_http_status(:found)
        expect(Category.count).to eq(1)
      end
    end

    describe 'PUT #update' do
      it 'updates the category' do
        category = create(:category)
        patch :update, params: { id: category.id, category: attributes_for(:category) }

        expect(response).to have_http_status(:found)
        expect(Category.find(category.id).name).to_not eq(category.name)
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the category' do
        category = create(:category)
        delete :destroy, params: { id: category.id }

        expect(response).to have_http_status(:found)
        expect(Category.find_by(id: category.id)).to be_nil
      end
    end
  end
end
