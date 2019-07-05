class RenameSeriesIdColumnInIssues < ActiveRecord::Migration[5.2]
  def change
    rename_column :issues, :series_id, :journal_id
  end
end
