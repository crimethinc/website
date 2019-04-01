require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #library' do
    it 'assigns all instance variables' do
      get :library

      expect(assigns[:html_id]).to eq('page')
      expect(assigns[:title]).to be_present
    end
  end

  describe 'GET #post_order_success' do
    it 'assigns all instance variables' do
      ordernum = '1312'

      get :post_order_success, params: { ordernum: ordernum }

      expect(assigns[:html_id]).to eq('page')
      expect(assigns[:title]).to be_present
      expect(assigns[:order_id]).to eq(ordernum)
    end
  end
end
