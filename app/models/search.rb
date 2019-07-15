class Search
  ARRAY_FILTERS = %w[tag category].freeze
  FILTER_REGEX  = /(\w+:(\w+|"[^"]+"))/.freeze
  VALID_FILTERS = %w[title subtitle content tag category].freeze

  attr_reader :query, :term

  def initialize query
    @filters = normalize_filters(query)
    @query   = query
    @scope   = SearchResult.select('search_results.*')
    @term    = strip_filters(query)
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

      self.scope =
        if ARRAY_FILTERS.include?(key)
          scope.where("#{key}::text[] @> ARRAY[?]", value)
        else
          scope.where("#{key} @@ plainto_tsquery(?)", value)
        end
    end

    scope
  end

  def full_text_search
    return scope if term.blank?

    self.scope = scope
                 .select("ts_rank(document, phraseto_tsquery('#{term}')) AS ranking")
                 .where('document @@ phraseto_tsquery(?)', term)
                 .order('ranking DESC')
  end

  def normalize_filters query
    query
      .scan(FILTER_REGEX)
      .map(&:first)
      .map { |filter| filter.split(':') }
      .select { |filter| VALID_FILTERS.include?(filter.first) }
      .map { |filter| [filter.first, filter.last.delete('"')] }
  end

  def strip_filters query
    filters = query.scan(FILTER_REGEX).map(&:first)

    filters.inject(query) { |q, match| q.sub(match, '') }.strip
  end
end
