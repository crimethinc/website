# passwordless auth for updating Stripe subscriptions
# see also `rake destroy_expired_support_sessions`

class SupportSession < ApplicationRecord
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
