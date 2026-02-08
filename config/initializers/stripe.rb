Rails.configuration.stripe = {
  publishable_key: Rails.application.config.x.stripe.publishable_key,
  secret_key:      Rails.application.config.x.stripe.secret_key,
  webhook_secret:  Rails.application.config.x.stripe.webhook_secret
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

STRIPE_MONTHLY_PRICE_ID = Rails.application.config.x.stripe.monthly_price_id
