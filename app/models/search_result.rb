class SearchResult < ApplicationRecord
  belongs_to :searchable, polymorphic: true

  def self.refresh
    # TEMP disabled because of PG out of memory error, 2019-10-09, @veganstraightedge
    # Scenic.database.refresh_materialized_view(:search_results, concurrently: true)
  end

  private

  def readonly?
    true
  end
end
