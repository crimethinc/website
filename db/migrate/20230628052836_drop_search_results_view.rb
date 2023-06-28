class DropSearchResultsView < ActiveRecord::Migration[7.0]
  def change
    drop_view :search_results, revert_to_version: 5, materialized: true
  end
end
