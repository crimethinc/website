class Search
  FILTER_REGEX  = /\w+:\w+/
  VALID_FILTERS = %w[title subtitle content tag category contributor].freeze

  attr_reader :query

  def initialize(query)
    @query   = normalize_query(query)
    @scope   = SearchResult
    @filters = normalize_filters(query)
  end

  def perform
    full_text_search
    apply_filters

    scope.map(&:searchable)
  end

  private

  attr_accessor :scope
  attr_reader :filters

  def apply_filters
    filters.each_pair do |filter, value|
      self.scope = scope.where("#{filter} @@ to_tsquery(?)", value)
    end

    scope
  end

  def full_text_search
    return scope unless query.present?

    self.scope = scope.where("document @@ to_tsquery(?)", query)
  end

  def normalize_filters(query)
    filters = query
              .scan(FILTER_REGEX)
              .map { |filter| filter.split(":") }
              .to_h
              .slice(*VALID_FILTERS)

    %w[tag category contributor].each do |key|
      filters["#{key}_names"] = filters.delete(key) if filters.has_key?(key)
    end

    filters
  end

  def normalize_query(query)
    filters = query.scan(FILTER_REGEX)

    filters.inject(query) { |q, match| q.sub(match, "") }.strip
  end
end
