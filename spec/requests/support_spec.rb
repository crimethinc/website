require 'rails_helper'

RSpec.describe 'Support' do
  before do
    host! 'example.com'
  end

  describe 'GET /support' do
    it 'renders the support page' do
      get support_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /support' do
    let(:checkout_session) { Struct.new(:url).new('https://checkout.stripe.com/c/pay/test_session') }

    context 'with a one-time donation' do
      before do
        allow(Stripe::Checkout::Session).to receive(:create).and_return(checkout_session)
      end

      it 'creates a payment checkout session and redirects to Stripe' do
        post support_create_path, params: { amount: 50, monthly: 'false' }

        expect(Stripe::Checkout::Session).to have_received(:create).with(
          hash_including(
            mode:        'payment',
            success_url: thanks_url,
            cancel_url:  support_url
          )
        )
        expect(response).to redirect_to('https://checkout.stripe.com/c/pay/test_session')
      end

      it 'sets line_items with inline price_data for the correct amount' do
        post support_create_path, params: { amount: 100, monthly: 'false' }

        expect(Stripe::Checkout::Session).to have_received(:create).with(
          hash_including(
            line_items: [{
              price_data: hash_including(
                currency:    'usd',
                unit_amount: 10_000
              ),
              quantity:   1
            }]
          )
        )
      end
    end

    context 'with a monthly subscription' do
      let(:price)      { Struct.new(:id).new('price_monthly_45') }
      let(:price_list) { Struct.new(:data).new([price]) }

      before do
        allow(Stripe::Price).to receive(:list).and_return(price_list)
        allow(Stripe::Checkout::Session).to receive(:create).and_return(checkout_session)
      end

      it 'looks up the price by lookup_key and creates a subscription checkout session' do
        post support_create_path, params: { amount: 45, monthly: 'true' }

        expect(Stripe::Price).to have_received(:list).with(
          lookup_keys: ['crimethinc_monthly_45'],
          limit:       1
        )
        expect(Stripe::Checkout::Session).to have_received(:create).with(
          hash_including(
            mode:       'subscription',
            line_items: [{ price: 'price_monthly_45', quantity: 1 }]
          )
        )
        expect(response).to redirect_to('https://checkout.stripe.com/c/pay/test_session')
      end
    end

    context 'when no price is found for the subscription amount' do
      let(:empty_price_list) { Struct.new(:data).new([]) }

      before do
        allow(Stripe::Price).to receive(:list).and_return(empty_price_list)
      end

      it 'redirects back to support with an error' do
        post support_create_path, params: { amount: 999, monthly: 'true' }

        expect(response).to redirect_to(support_path)
        expect(flash[:error]).to include('No price found')
      end
    end

    context 'when Stripe raises an error' do
      before do
        allow(Stripe::Checkout::Session).to receive(:create)
          .and_raise(Stripe::StripeError.new('Something went wrong'))
      end

      it 'redirects back to support with the error message' do
        post support_create_path, params: { amount: 50, monthly: 'false' }

        expect(response).to redirect_to(support_path)
        expect(flash[:error]).to eq('Something went wrong')
      end
    end
  end

  describe 'GET /thanks' do
    it 'renders the thanks page' do
      get thanks_path

      expect(response).to have_http_status(:ok)
    end
  end
end
