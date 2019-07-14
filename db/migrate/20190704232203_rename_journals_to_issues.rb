class RenameJournalsToIssues < ActiveRecord::Migration[5.2]
  def change
    rename_table :journals, :issues
  end
end
