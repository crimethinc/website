Rails.configuration.stripe = {
  publishable_key:     Rails.application.config.x.stripe.publishable_key,
  secret_key:          Rails.application.config.x.stripe.secret_key,
  customer_portal_url: Rails.application.config.x.stripe.customer_portal_url
}

Stripe.api_key     = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2026-01-28.clover'
