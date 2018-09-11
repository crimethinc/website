class SubscriptionSession < ApplicationRecord
  validates :stripe_customer_id, :token, :expires_at, presence: true
  validates :stripe_customer_id, :token, uniqueness: true
end
