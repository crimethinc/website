class DropSupportSessions < ActiveRecord::Migration[7.2]
  def change
    drop_table :support_sessions do |t|
      t.datetime :expires_at, precision: nil
      t.string :stripe_customer_id
      t.string :token
      t.index :stripe_customer_id, unique: true
    end
  end
end
