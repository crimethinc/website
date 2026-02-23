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

  describe 'POST /support/create_session' do
    let(:customer)      { Struct.new(:id).new('cus_test_123') }
    let(:subscriptions) { Struct.new(:data).new([Struct.new(:id).new('sub_test_1')]) }

    context 'when a subscriber exists with an active subscription' do
      let(:mailer_double) { instance_double(ActionMailer::MessageDelivery) }

      before do
        allow(Stripe::Customer).to receive(:list)
          .and_return(Struct.new(:data).new([customer]))
        allow(Stripe::Subscription).to receive(:list)
          .and_return(subscriptions)

        mailer = instance_double(SupportMailer)
        allow(SupportMailer).to receive(:with).and_return(mailer)
        allow(mailer).to receive(:edit_subscription).and_return(mailer_double)
        allow(mailer_double).to receive(:deliver_now)
      end

      it 'sends an email and redirects with a success notice' do
        post support_request_path, params: { email: 'donor@example.com' }

        expect(mailer_double).to have_received(:deliver_now)
        expect(response).to redirect_to(support_path)
        expect(flash[:notice]).to include('donor@example.com')
      end

      it 'creates a SupportSession' do
        expect do
          post support_request_path, params: { email: 'donor@example.com' }
        end.to change(SupportSession, :count).by(1)
      end
    end

    context 'when no subscriber is found' do
      before do
        allow(Stripe::Customer).to receive(:list)
          .and_return(Struct.new(:data).new([]))
      end

      it 'redirects with an error' do
        post support_request_path, params: { email: 'nobody@example.com' }

        expect(response).to redirect_to(support_path)
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'GET /support/edit/:token' do
    let(:portal_session) { Struct.new(:url).new('https://billing.stripe.com/p/session/test_portal') }

    context 'with a valid token' do
      before do
        SupportSession.create!(
          stripe_customer_id: 'cus_test_123',
          token:              'valid_token',
          expires_at:         30.minutes.from_now
        )
        allow(Stripe::BillingPortal::Session).to receive(:create).and_return(portal_session)
      end

      it 'creates a portal session and redirects to Stripe' do
        get support_edit_path(token: 'valid_token')

        expect(Stripe::BillingPortal::Session).to have_received(:create).with(
          customer:   'cus_test_123',
          return_url: support_url
        )
        expect(response).to redirect_to('https://billing.stripe.com/p/session/test_portal')
      end

      it 'destroys the support session after use' do
        expect do
          get support_edit_path(token: 'valid_token')
        end.to change(SupportSession, :count).by(-1)
      end
    end

    context 'with an expired token' do
      before do
        SupportSession.create!(
          stripe_customer_id: 'cus_test_456',
          token:              'expired_token',
          expires_at:         1.hour.ago
        )
      end

      it 'redirects to support with an error' do
        get support_edit_path(token: 'expired_token')

        expect(response).to redirect_to(support_path)
        expect(flash[:error]).to include('expired')
      end
    end

    context 'with an invalid token' do
      it 'redirects to support with an error' do
        get support_edit_path(token: 'nonexistent')

        expect(response).to redirect_to(support_path)
        expect(flash[:error]).to include('expired')
      end
    end
  end

  describe 'POST /support/stripe_subscription_payment_succeeded_webhook' do
    let(:webhook_url) { '/support/stripe_subscription_payment_succeeded_webhook' }
    let(:payload)     { { type: 'invoice.payment_succeeded' }.to_json }
    let(:secret)      { Rails.configuration.stripe[:webhook_secret] }

    let(:timestamp) { Time.now.to_i }

    let(:sig_header) do
      signed_payload = "#{timestamp}.#{payload}"
      signature = OpenSSL::HMAC.hexdigest('SHA256', secret, signed_payload)
      "t=#{timestamp},v1=#{signature}"
    end

    it 'returns 200 with a valid signature' do
      post webhook_url,
           env:     { 'RAW_POST_DATA' => payload },
           headers: { 'HTTP_STRIPE_SIGNATURE' => sig_header, 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:ok)
    end

    it 'returns 400 with an invalid signature' do
      post webhook_url,
           env:     { 'RAW_POST_DATA' => payload },
           headers: { 'HTTP_STRIPE_SIGNATURE' => 't=123,v1=badsig', 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 with no signature header' do
      post webhook_url,
           env:     { 'RAW_POST_DATA' => payload },
           headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET /thanks' do
    it 'renders the thanks page' do
      get thanks_path

      expect(response).to have_http_status(:ok)
    end
  end
end
