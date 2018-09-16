# We have made every effort to always refer to instances of this class
# as 'subscription_sessions' instead of 'subscriptions' because Stripe
# has subscriptions and these are just here for passwordless auth.

class SubscriptionSession < ApplicationRecord
  validates :stripe_customer_id, :token, :expires_at, presence: true
  validates :stripe_customer_id, :token, uniqueness: true

  def expired?
    expires_at < Time.current
  end
end
