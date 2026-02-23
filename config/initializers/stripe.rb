Rails.configuration.stripe = {
  publishable_key: Rails.application.config.x.stripe.publishable_key,
  secret_key:      Rails.application.config.x.stripe.secret_key,
  webhook_secret:  Rails.application.config.x.stripe.webhook_secret
}

Stripe.api_key     = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2026-01-28.clover'
