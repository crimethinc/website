class SearchResult < ApplicationRecord
  belongs_to :searchable, polymorphic: true

  def self.refresh
    Scenic.database.refresh_materialized_view(:search_results, concurrently: true)
  end

  private

  def readonly?
    true
  end
end
