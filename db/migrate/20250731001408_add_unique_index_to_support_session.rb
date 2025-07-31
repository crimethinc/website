class AddUniqueIndexToSupportSession < ActiveRecord::Migration[8.0]
  def change
    add_index :support_sessions, :stripe_customer_id, unique: true
  end
end
