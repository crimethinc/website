class SupportController < ApplicationController
  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = PageTitle.new t('views.support.new.heading')

    render "#{Current.theme}/support/new"
  end

  def thanks
    @html_id = 'page'
    @body_id = 'support'
    @title   = PageTitle.new t('views.support.thanks.heading')

    render "#{Current.theme}/support/thanks"
  end

  def create
    session = if params[:monthly] == 'true'
                create_subscription_checkout_session
              else
                create_payment_checkout_session
              end

    redirect_to session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to support_path
  end

  private

  def create_subscription_checkout_session
    amount = params[:amount].to_i
    prices = Stripe::Price.list(lookup_keys: ["crimethinc_monthly_#{amount}"], limit: 1)
    price  = prices.data.first

    raise Stripe::InvalidRequestError.new("No price found for $#{amount}/mo", nil) if price.nil?

    Stripe::Checkout::Session.create(
      mode:        'subscription',
      line_items:  [{ price: price.id, quantity: 1 }],
      success_url: thanks_url,
      cancel_url:  support_url
    )
  end

  def create_payment_checkout_session
    amount = params[:amount].to_i

    Stripe::Checkout::Session.create(
      mode:        'payment',
      line_items:  [{
        price_data: {
          currency:     'usd',
          product_data: { name: t('views.support.new.description_one_time') },
          unit_amount:  amount * 100
        },
        quantity:   1
      }],
      success_url: thanks_url,
      cancel_url:  support_url
    )
  end
end
