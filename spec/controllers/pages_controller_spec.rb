require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #library' do
    it 'assigns all instance variables' do
      get :library

      expect(assigns[:html_id]).to eq('page')
      expect(assigns[:title]).to be_present
    end
  end
end
