class DonationsController < ApplicationController
  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = I18n.t('views.donations.support.heading')
  end

  def thanks
    @html_id = 'page'
    @body_id = 'support'
    @title   = I18n.t('views.donations.thanks.heading')
  end

  def create
    amount = params[:amount]

    customer = Stripe::Customer.create(
      email: params['js-stripe-email'],
      source: params['js-stripe-token']
    )

    if params[:monthly] == 'true'
      Stripe::Subscription.create(
        customer: customer.id,
        plan:     STRIPE_MONTHLY_PLAN_ID,
        quantity: amount
      )
    else
      Stripe::Charge.create(
        customer:    customer.id,
        amount:     amount.to_i * 100,
        description: t('views.donations.support.description_one_time'),
        currency:    'usd'
      )
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  else
    redirect_to [:thanks]
  end
end
