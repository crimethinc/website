class DropSearchResultsView < ActiveRecord::Migration[7.0]
  def change
    # drop_view :search_results, revert_to_version: 5, materialized: true
    # NO OP: because scenic gem has been removed
    # TODO: this migration will get squashed away in the next squashing
  end
end
