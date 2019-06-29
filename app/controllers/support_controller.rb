class SupportController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = t('views.support.new.heading')
  end

  def create
    if params[:monthly] == 'true' && customer_with_subscription(stripe_options[:email])
      flash[:error] = t('views.support.create.repeat_subscriber_error')
      return redirect_to [:support]
    end

    params[:monthly] == 'true' ? create_stripe_subscription : create_stripe_charge
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

    if customer.blank?
      flash[:error] = t('views.support.create_session.no_existing_customer_error')
      return redirect_to [:support]
    end

    support_session = SupportSession.new(
      stripe_customer_id: customer.id, token: SupportSession.generate_token, expires_at: 1.hour.from_now
    )

    if support_session.save
      mailer_options = { email: email, support_session: support_session, host: request.host_with_port }
      SupportMailer.with(mailer_options).edit_subscription.deliver_now

      flash[:notice] = t('views.support.create_session.success_notice', email: email)
    else
      flash[:error] = t('views.support.create_session.repeat_customer_error')
    end

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
      @next_invoice = Stripe::Invoice.upcoming(customer: @customer.id)
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

  def stripe_options
    {
      amount: params[:amount],
      email:  params[:js_stripe_email],
      source: params[:js_stripe_token]
    }
  end

  def customer_with_subscription email
    customers = Stripe::Customer.list(email: email).data

    customers.each do |customer|
      customers.delete(customer) if customer.subscriptions.data.empty?
    end

    customers.first # returns nil if empty
  end

  def create_stripe_subscription
    Stripe::Subscription.create(
      customer: stripe_customer.id,
      plan:     STRIPE_MONTHLY_PLAN_ID,
      quantity: stripe_options[:amount]
    )
  end

  def create_stripe_charge
    Stripe::Charge.create(
      currency:      'usd',
      customer:      stripe_customer.id,
      amount:        stripe_options[:amount].to_i * 100, # charges need to be in cents
      description:   t('views.support.new.description_one_time'),
      receipt_email: stripe_customer.email
    )
  end

  def stripe_customer
    stripe_options_without_amount = stripe_options.reject { |k, _v| k == :amount }

    @stripe_customer ||= Stripe::Customer.create stripe_options_without_amount
  end
end
