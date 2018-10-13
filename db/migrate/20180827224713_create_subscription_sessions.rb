class CreateSubscriptionSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_sessions do |t|
      t.string :stripe_customer_id
      t.string :token
      t.datetime :expires_at
    end
  end
end
