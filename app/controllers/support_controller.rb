class SupportController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = t('views.support.new.heading')
  end

  def create
    amount = params[:amount]
    email  = params[:js_stripe_email]
    source = params[:js_stripe_token]

    if params[:monthly] == 'true'
      if customer_with_subscription(email)
        flash[:error] = t('views.support.create.repeat_subscriber_error')
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
    @title   = t('views.support.thanks.heading')
  end

  def create_session
    email = params[:email]
    customer = customer_with_subscription(email)

    if customer.nil?
      flash[:error] = t('views.support.create_session.no_existing_customer_error')
    else
      support_session = SupportSession.create!(
        stripe_customer_id: customer.id,
        token:              SupportSession.generate_token,
        expires_at:         1.hour.from_now
      )

      SupportMailer.with(
        email: email,
        support_session: support_session,
        host: request.host_with_port
      ).edit_subscription.deliver_later

      flash[:notice] = t('views.support.create_session.success_notice', email: email).html_safe
    end
  rescue ActiveRecord::RecordInvalid
    # SupportSession already exists for that stripe_customer_id
    flash[:error] = t('views.support.create_session.repeat_customer_error')
    redirect_to [:support]
  else
    redirect_to [:support]
  end

  def edit
    @html_id = 'page'
    @body_id = 'support-edit'
    @title   = t('views.support.edit.heading')

    @support_session = SupportSession.find_by token: params[:token]

    if @support_session.nil? || @support_session.expired?
      flash[:error] = t('views.support.edit.expired_link_error')
      redirect_to [:support]
      return
    else
      @customer = Stripe::Customer.retrieve(
        id:     @support_session.stripe_customer_id,
        expand: ['default_source'] # for future credit card updates
      )
      @subscription = @customer.subscriptions.data.first
    end
  end

  def update_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])
    subscription.quantity = params[:amount].to_i

    if subscription&.save
      flash[:notice] = t('views.support.update_subscription.notice')
    else
      flash[:error] = t('views.support.update_subscription.error')
    end

    redirect_to [:support_edit, token: params[:token]]
  end

  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])

    if subscription&.delete
      SupportSession.find_by(token: params[:token]).destroy
      flash[:notice] = t('views.support.cancel_subscription.notice')
    else
      flash[:error] = t('views.support.cancel_subscription.error')
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
