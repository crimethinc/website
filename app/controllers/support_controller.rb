class SupportController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = I18n.t('views.support.new.heading')
  end

  def create
    amount = params[:amount]
    email  = params[:js_stripe_email]
    source = params[:js_stripe_token]

    if params[:monthly] == 'true'
      if customer_with_subscription(email)
        flash[:error] = "We already have a monthly subscriber with that email address. If you'd still like to give more, try a one-time donation. Thanks!"
        redirect_to [:support]
        return
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
        description:   t('views.support.new.description_one_time'),
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
    @title   = I18n.t('views.support.thanks.heading')
  end

  def create_session
    email = params[:email]
    customer = customer_with_subscription(email)

    if customer.nil?
      flash[:error] = 'We can’t find any monthly subscribers with that email address. If you think this is in error, please [send us an email](mailto:info@crimethinc.com) so we can help you.'
    else
      subscription_session = SubscriptionSession.create!(
        stripe_customer_id: customer.id,
        token:              SubscriptionSession.generate_token,
        expires_at:         1.hour.from_now
      )

      SubscriptionMailer.with(
        email: email,
        subscription_session: subscription_session,
        host: request.host_with_port
      ).edit.deliver_later

      flash[:notice] = "We sent an email to #{email} with a link to make changes to your subscription."
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "You already submitted a request. Look for an email from _info@crimethinc.com_. If you've lost your super secret link, wait an hour and try again."
    redirect_to [:support]
  else
    redirect_to [:support]
  end

  def edit
    @html_id = 'page'
    @body_id = 'support-edit'
    @title   = 'Update your Support' # I18n.t('views.support.new.heading')

    @subscription_session = SubscriptionSession.find_by token: params[:token]

    if @subscription_session.nil? || @subscription_session.expired?
      flash[:error] = 'That link has expired. Please try again.'
      redirect_to [:support]
      return
    else
      @customer = Stripe::Customer.retrieve(
        id:     @subscription_session.stripe_customer_id,
        expand: ['default_source'] # for future credit card updates
      )
      @subscription = @customer.subscriptions.data.first
    end
  end

  def update_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])
    subscription.quantity = params[:amount].to_i

    if subscription&.save
      flash[:notice] = 'Your subscription amount has been updated!'
    else
      flash[:error] = 'There was a problem updating your subscription. Try again! If the problem continues, please [send us an email](mailto:support@crimethinc.com) so we can help you.'
    end

    redirect_to [:support_edit, token: params[:token]]
  end

  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])

    if subscription&.delete
      SubscriptionSession.find_by(token: params[:token]).destroy
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
      charge.description   = t('views.support.new.description_monthly')
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
