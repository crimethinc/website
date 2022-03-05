class AddTimestampsToIssues < ActiveRecord::Migration[7.0]
  def change
    change_table :issues, bulk: true do |t|
      t.datetime :created_at, precision: nil
      t.datetime :updated_at, precision: nil
    end
  end
end
