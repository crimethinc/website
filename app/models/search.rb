class Search
  FILTER_REGEX  = /\w+:\w+/
  VALID_FILTERS = %w[title subtitle content tag category contributor].freeze

  attr_reader :query

  def initialize(query)
    @filters = normalize_filters(query)
    @query   = query
    @scope   = SearchResult.select("search_results.*")
  end

  def perform
    full_text_search
    apply_filters

    scope
  end

  private

  attr_accessor :scope
  attr_reader :filters

  def apply_filters
    filters.each do |filter|
      key   = filter.first
      value = filter.last

      self.scope = scope.where("#{key} @@ to_tsquery(?)", value)
    end

    scope
  end

  def full_text_search
    term = strip_filters(query)
    return scope unless term.present?

    self.scope = scope
                 .select("ts_rank(document, phraseto_tsquery('#{term}')) AS ranking")
                 .where("document @@ phraseto_tsquery(?)", term)
                 .order("ranking DESC")
  end

  def normalize_filters(query)
    filters = query
              .scan(FILTER_REGEX)
              .map { |filter| filter.split(":") }
              .select { |filter| VALID_FILTERS.include?(filter.first) }

    filters
  end

  def strip_filters(query)
    filters = query.scan(FILTER_REGEX)

    filters.inject(query) { |q, match| q.sub(match, "") }.strip
  end
end
