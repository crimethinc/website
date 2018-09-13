# TODO: explain what this is, how is it NOT a Subscription
class SubscriptionSession < ApplicationRecord
  validates :stripe_customer_id, :token, :expires_at, presence: true
  validates :stripe_customer_id, :token, uniqueness: true

  def expired?
    expires_at > Time.current
  end
end
