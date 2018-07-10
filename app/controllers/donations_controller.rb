class DonationsController < ApplicationController
  protect_from_forgery except: :stripe_webhooks

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
    # number of 'units', each unit is $1
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
        amount:     amount.to_i * 100, # charges are in cents
        description: t('views.donations.support.description_one_time'),
        currency:    'usd',
        receipt_email: customer.email
      )
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  else
    redirect_to [:thanks]
  end

  def stripe_webhooks
    event_json = JSON.parse(request.body.read)

    if event_json["type"] == "invoice.payment_succeeded"
      customer_id = event_json["data"]["object"]["customer"]
      customer  = Stripe::Customer.retrieve("cus_DCbYHIi93Ldej7")

      charge_id = event_json["data"]["object"]["charge"]
      charge    = Stripe::Charge.retrieve(charge_id)

      charge.receipt_email = customer.email
      charge.description = t('views.donations.support.description_monthly')
      charge.save
    end

    head :ok
  end
end
