class SearchResult < ApplicationRecord
  belongs_to :searchable, polymorphic: true

  def self.refresh
    # TODO: FIXME: TEMP: re-enable this when fixed
    #   2018-12-31 @veganstraightedge
    #   ActiveRecord::StatementInvalid: PG::NullValueNotAllowed:
    #   ERROR:  lexeme array may not contain nulls:
    #   REFRESH MATERIALIZED VIEW CONCURRENTLY "search_results";
    #   Location: app/models/search_result.rb:5 - refresh

    # Scenic.database.refresh_materialized_view(:search_results, concurrently: true)
  end

  private

  def readonly?
    true
  end
end
