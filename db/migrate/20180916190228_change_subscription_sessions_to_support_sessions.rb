class ChangeSubscriptionSessionsToSupportSessions < ActiveRecord::Migration[5.2]
  def change
    rename_table :subscription_sessions, :support_sessions
  end
end
