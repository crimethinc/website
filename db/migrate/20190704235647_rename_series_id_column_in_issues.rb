class RenameSeriesIdColumnInIssues < ActiveRecord::Migration[5.2]
  def change
    rename_column :issues, :series_id, :journals_id
  end
end
