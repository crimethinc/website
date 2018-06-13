class DonationsController < ApplicationController

  def show
  end


  def new
    @amounts = (1..100).to_a + [200,300,400,500,600,700,800,900,1000]
    @amounts = @amounts.map{ |amount| ["$#{amount}", amount] }
  end

  def create
    customer = Stripe::Customer.create(
      email: params["js-stripe-email"],
      source: params["js-stripe-token"]
    )

    if params[:monthly] == "true"
      Stripe::Subscription.create(
        customer: customer.id,
        plan:     STRIPE_MONTHLY_PLAN_ID,
        quantity: params[:amount]
      )
    else
      Stripe::Charge.create(
        customer:    customer.id,
        amount:      params[:amount].to_i * 100,
        description: t("views.donations.description_once"),
        currency:    'usd'
      )
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  else
    redirect_to [:donation]
  end
end
