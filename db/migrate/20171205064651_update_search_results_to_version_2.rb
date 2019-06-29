class UpdateSearchResultsToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :search_results,
                version:           2,
                revert_to_version: 1,
                materialized:      true
  end
end
