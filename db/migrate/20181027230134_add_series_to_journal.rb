class AddSeriesToJournal < ActiveRecord::Migration[5.2]
  def change
    add_column :journals, :series_id, :integer
    add_column :journals, :issue, :integer
  end
end
