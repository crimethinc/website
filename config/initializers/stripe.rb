Rails.configuration.stripe = {
  publishable_key: Rails.application.config.x.stripe.publishable_key,
  secret_key:      Rails.application.config.x.stripe.secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

STRIPE_MONTHLY_PRICE_ID = Rails.application.config.x.stripe.monthly_price_id
