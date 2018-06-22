class DonationsController < ApplicationController
  def new
    @html_id = 'page'
    @body_id = 'support'
    @amounts = (1..100).to_a + %w[200 300 400 500 600 700 800 900 1000]
    @amounts_for_select = @amounts.map { |amount| ["$#{amount}", amount] }
  end

  def create
    customer = Stripe::Customer.create(
      email: params['js-stripe-email'],
      source: params['js-stripe-token']
    )

    if params[:monthly] == 'true'
      Stripe::Subscription.create(
        customer: customer.id,
        plan:     STRIPE_MONTHLY_PLAN_ID,
        quantity: params[:amount]
      )
    else
      Stripe::Charge.create(
        customer:    customer.id,
        amount:      params[:amount].to_i * 100,
        description: t('views.donations.description_once'),
        currency:    'usd'
      )
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  else
    redirect_to [:thanks]
  end

  def thanks
    @html_id = 'page'
    @body_id = 'support'
  end
end
