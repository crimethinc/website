class DonationsController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = I18n.t('views.donations.support.heading')
  end

  def create
    # number of 'units', each unit is $1
    amount = params[:amount]

    @customer = find_or_create_customer(
      email:  params['js-stripe-email'],
      source: params['js-stripe-token']
    )

    if params[:monthly] == 'true'
      Stripe::Subscription.create(
        customer: @customer.id,
        plan:     STRIPE_MONTHLY_PLAN_ID,
        quantity: amount
      )
    else
      Stripe::Charge.create(
        currency:      'usd',
        customer:      @customer.id,
        amount:        amount.to_i * 100, # charges need to be in cents
        description:   t('views.donations.support.description_one_time'),
        receipt_email: @customer.email
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
    @title   = I18n.t('views.donations.thanks.heading')
  end

  def create_session
    email     = params[:email]
    customers = Stripe::Customer.list(email: email).data

    customers.each do |customer|
      customers.delete(customer) if customer.subscriptions.data.empty?
    end

    if customers.empty?
      flash[:error] = 'We can’t find any subscriptions with that email address. If you think this is in error, please [send us an email](mailto:info@crimethinc.com) so we can help you.'
    elsif customers.one?
      subscription = SubscriptionSession.create!(
        stripe_customer_id: customers.first.id,
        token:              SecureRandom.hex,
        expires_at:         1.hour.from_now
      )

      SubscriptionMailer.with(subscription: subscription, email: email).edit.deliver_later

      flash[:notice] = 'We sent you an email with a link to do the thing you need to do.'
    else
      flash[:error] = 'We found multiple subscriptions with that email address. Please [send us an email](mailto:info@crimethinc.com) so we can help you.'
    end

    redirect_to [:support]
  end

  def edit
    session = SubscriptionSession.find_by token: params[:token]

    if session
      @customer = Stripe::Customer.retrieve(
        id:     session.stripe_customer_id,
        expand: ['default_source']
      )
    else
      flash[:error] = 'That link has expired. Please try again.'
      redirect_to [:support]
    end
  end

  def update_subscription
    if params[:amount].present?
      subscription = Stripe::Subscription.retrieve(params[:subscription_id])
      subscription.quantity = params[:amount].to_i

      if subscription&.save
        flash[:notice] = 'Your subscription amount has been updated!'
      else
        flash[:error] = 'There was a problem updating your subscription. Try again! If the problem continues, please [send us an email](mailto:support@crimethinc.com) so we can help you.'
      end
    else
      flash[:error] = 'You must first select an amount to update.'
    end

    redirect_to support_edit_path(params[:token])
  end

  def cancel
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])

    if subscription&.delete
      flash[:notice] = 'Your subscription has been canceled.'
    else
      flash[:error] = 'There was a problem canceling your subscription. Try again! If the problem continues, please [send us an email](mailto:support@crimethinc.com) so we can help you.'
    end

    redirect_to [:support]
  end

  def stripe_subscription_payment_succeeded_webhook
    event = JSON.parse(request.body.read)

    if event['type'] == 'invoice.payment_succeeded'
      customer_id = event['data']['object']['customer']
      customer    = Stripe::Customer.retrieve(customer_id)

      charge_id = event['data']['object']['charge']
      charge    = Stripe::Charge.retrieve(charge_id)

      charge.receipt_email = customer.email
      charge.description   = t('views.donations.support.description_monthly')
      charge.save
    end

    head :ok
  end

  private

  def find_or_create_customer email:, source:
    return if email.blank? || source.blank?

    customers = Stripe::Customer.list(email: email).data

    if customers.present?
      customers.first
    else
      create_customer(email, source)
    end
  end

  def create_customer(email, source)
    Stripe::Customer.create(
      email: email,
      source: source
    )
  end
end
