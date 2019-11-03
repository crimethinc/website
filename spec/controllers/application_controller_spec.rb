require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :authorize, only: [:destroy]
    before_action :set_title

    def index
      signed_in?

      render plain: 'index'
    end

    def new
      render plain: 'new'
    end

    def show
      render plain: 'show'
    end

    def edit
      render plain: 'edit'
    end

    def destroy
      render plain: 'authorized'
    end

    def set_title
      @title = params[:title]
    end
  end

  describe '#current_user' do
    let(:user) { User.create(username: 'example', password: 'x' * 30) }

    it 'loads from session' do
      session[:user_id] = user.id

      get :index

      expect(assigns[:current_user]).to eq(user)
    end

    it 'doesn’t break with no session' do
      get :index

      expect(assigns[:current_user]).to be_nil
    end
  end

  describe '#signed_in?' do
    let(:user) { User.create(username: 'example', password: 'x' * 30) }

    it 'is true with a user' do
      session[:user_id] = user.id

      get :index

      expect(controller).to be_signed_in
    end

    it 'is false with no user' do
      get :index

      expect(controller).not_to be_signed_in
    end
  end

  describe '#authorize' do
    let(:user) { User.create(username: 'example', password: 'x' * 30) }

    it 'renders with a user' do
      session[:user_id] = user.id

      get :destroy, params: { id: 1 }

      expect(response.status).to eq(200)
    end

    it 'is false with no user' do
      get :destroy, params: { id: 1 }

      expect(response.status).to eq(302)
    end
  end

  describe '#check_for_redirection' do
    it 'redirects temporarily when present' do
      Redirect.create(source_path: '/anonymous', target_path: 'http://example.com', temporary: true)

      get :index

      expect(response.status).to eq(302)
    end

    it 'redirects permanently when present' do
      Redirect.create(source_path: '/anonymous', target_path: 'http://example.com', temporary: false)

      get :index

      expect(response.status).to eq(301)
    end
  end

  describe '#strip_file_extension' do
    it 'strips .html' do
      get :index, format: 'html'

      expect(response.status).to eq(302)
    end
  end

  # describe '#current_resource_name' do
  #   # TODO: migrate this spec from admin_helper_spec to application_controller_spec
  #   before { expect(helper.request).to receive(:path) { 'admin/things/id' } }
  #
  #   subject { helper.current_resource_name }
  #
  #   it { is_expected.to eq('Thing') }
  # end
end
