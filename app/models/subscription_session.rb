# We have made every effort to always refer to instances of this class
# as 'subscription_sessions' instead of 'subscriptions' because Stripe
# has subscriptions and these are just here for passwordless auth.

class SubscriptionSession < ApplicationRecord
  validates :stripe_customer_id, :token, :expires_at, presence: true
  validates :stripe_customer_id, :token, uniqueness: true

  def self.generate_token
    loop do
      new_token = SecureRandom.urlsafe_base64(nil, false)
      break new_token unless all.exists?(token: new_token)
    end
  end

  def expired?
    expires_at < Time.current
  end
end
