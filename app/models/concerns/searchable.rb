module Searchable
  extend ActiveSupport::Concern

  included do
    after_save :refresh_search_view
  end

  def refresh_search_view
    SearchResult.refresh
  end
end
