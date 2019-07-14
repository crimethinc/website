class RenameSeriesToJournals < ActiveRecord::Migration[5.2]
  def change
    rename_table :series, :journals
  end
end
