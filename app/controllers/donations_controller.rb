class DonationsController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = I18n.t('views.donations.support.heading')
  end

  def create
    amount = params[:amount]
    email  = params[:js_stripe_email]
    source = params[:js_stripe_token]

    if params[:monthly] == 'true'
      if customer_with_subscription(email)
        flash[:error] = "We already have a monthly subscriber with that email address. If you'd still like to give more, try a one-time donation. Thanks!"
        redirect_to [:support] and return
      else
        customer = create_customer(email: email, source: source)
        Stripe::Subscription.create(
          customer: customer.id,
          plan:     STRIPE_MONTHLY_PLAN_ID,
          quantity: amount
        )
      end
    else
      customer = create_customer(email: email, source: source)
      Stripe::Charge.create(
        currency:      'usd',
        customer:      customer.id,
        amount:        amount.to_i * 100, # charges need to be in cents
        description:   t('views.donations.support.description_one_time'),
        receipt_email: customer.email
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
    customer = customer_with_subscription(params[:email])

    if customer.nil?
      flash[:error] = 'We can’t find any monthly subscribers with that email address. If you think this is in error, please [send us an email](mailto:info@crimethinc.com) so we can help you.'
    else
      subscription = SubscriptionSession.create!(
        stripe_customer_id: customers.first.id,
        token:              SecureRandom.hex,
        expires_at:         1.hour.from_now
      )

      SubscriptionMailer.with(
        email: email,
        subscription: subscription,
        host: request.host_with_port
      ).edit.deliver_later

      flash[:notice] = 'We sent you an email with a link to do the thing you need to do.'
    end

    redirect_to [:support]
  end

  def edit
    @html_id = 'page'
    @body_id = 'support-edit'
    @title   = 'Update your Support' # I18n.t('views.donations.support.heading')

    @subscription_session = SubscriptionSession.find_by token: params[:token]

    if @subscription_session&.expired?
      @customer = Stripe::Customer.retrieve(
        id:     @subscription_session.stripe_customer_id,
        expand: ['default_source']
      )
    else
      flash[:error] = 'That link has expired. Please try again.'
      redirect_to [:support]
    end
  end

  def update_subscription
    # TODO: user slider in view, remove outer if/else
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

    redirect_to [:support_edit, token: params[:token]]
  end

  def cancel
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])
    # TODO: delete SubscriptionSession too

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

  def customer_with_subscription(email)
    customers = Stripe::Customer.list(email: email).data

    customers.each do |customer|
      customers.delete(customer) if customer.subscriptions.data.empty?
    end

    customers.empty? ? nil : customers.first
  end

  def create_customer(email:, source:)
    Stripe::Customer.create(email: email, source: source)
  end
end
