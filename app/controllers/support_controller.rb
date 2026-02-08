class SupportController < ApplicationController
  protect_from_forgery except: :stripe_subscription_payment_succeeded_webhook

  def new
    @html_id = 'page'
    @body_id = 'support'
    @title   = PageTitle.new t('views.support.new.heading')

    render "#{Current.theme}/support/new"
  end

  def edit
    @html_id = 'page'
    @body_id = 'support-edit'
    @title   = PageTitle.new t('views.support.edit.heading')

    @support_session = SupportSession.find_by token: params[:token]

    if @support_session.nil? || @support_session.expired?
      flash.now[:error] = t('views.support.edit.expired_link_error')
      redirect_to [:support]
      return
    else
      @customer = Stripe::Customer.retrieve(
        id:     @support_session.stripe_customer_id,
        expand: %w[default_source subscriptions] # for future credit card updates
      )
      @subscription = @customer.subscriptions.data.first
      @next_invoice = Stripe::Invoice.upcoming(customer: @customer.id)
    end

    render "#{Current.theme}/support/edit"
  end

  def thanks
    @html_id = 'page'
    @body_id = 'support'
    @title   = PageTitle.new t('views.support.thanks.heading')

    render "#{Current.theme}/support/thanks"
  end

  def create_session
    email = params[:email]
    customer = customer_with_subscription(email)

    if customer.blank?
      flash[:error] = t('views.support.create_session.no_existing_customer_error')
      return redirect_to [:support]
    end

    support_session = SupportSession.new(stripe_customer_id: customer.id,
                                         token:              SupportSession.generate_token,
                                         expires_at:         1.hour.from_now)

    if support_session.save
      mailer_options = { email: email, support_session: support_session, host: request.host_with_port }
      SupportMailer.with(mailer_options).edit_subscription.deliver_now

      flash.now[:notice] = t('views.support.create_session.success_notice', email: email)
    else
      flash.now[:error] = t('views.support.create_session.repeat_customer_error')
    end

    redirect_to [:support]
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

  def update_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])
    subscription.quantity = params[:amount].to_i

    if subscription&.save
      flash.now[:notice] = t('views.support.update_subscription.notice')
    else
      flash.now[:error] = t('views.support.update_subscription.error')
    end

    redirect_to [:support_edit, { token: params[:token] }]
  end

  def cancel_subscription
    subscription = Stripe::Subscription.retrieve(params[:subscription_id])

    if subscription&.cancel
      SupportSession.find_by(token: params[:token]).destroy
      flash.now[:notice] = t('views.support.cancel_subscription.notice')
    else
      flash.now[:error] = t('views.support.cancel_subscription.error')
    end

    redirect_to [:support]
  end

  def stripe_subscription_payment_succeeded_webhook
    payload   = request.body.read
    sig       = request.env['HTTP_STRIPE_SIGNATURE']
    secret    = Rails.configuration.stripe[:webhook_secret]

    Stripe::Webhook.construct_event(payload, sig, secret)

    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end

  private

  def customer_with_subscription email
    customers = Stripe::Customer.list(email: email, expand: %w[data.subscriptions]).data

    customers.each do |customer|
      customers.delete(customer) if customer.subscriptions.data.empty?
    end

    customers.first # returns nil if empty
  end

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
