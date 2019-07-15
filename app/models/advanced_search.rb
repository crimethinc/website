class AdvancedSearch
  include ActiveModel::Model

  def initialize query = ''
    @query = query.to_s
  end

  def update attributes
    attributes.each_pair do |key, value|
      send("#{key}=", value)
    end

    self
  end

  def query
    @query.strip
  end

  def category= categories
    categories.to_s.split(',').map(&:strip).each do |category|
      @query += "category:#{category}" + ' '
    end
  end

  def category
    filters
      .select { |filter| filter.first == 'category' }
      .map(&:last)
      .map { |c| c.delete('"') }
      .join(', ')
  end

  def content= content
    content.to_s.split.map(&:strip).each do |c|
      @query += "content:#{c}" + ' '
    end
  end

  def content
    filters.select { |filter| filter.first == 'content' }.map(&:last).join(' ')
  end

  def tag= tags
    tags.to_s.split(',').map(&:strip).each do |tag|
      tag = tag.inspect if tag.match?(/\s/)

      @query += "tag:#{tag}" + ' '
    end
  end

  def tag
    filters
      .select { |filter| filter.first == 'tag' }
      .map(&:last)
      .map { |c| c.delete('"') }
      .join(', ')
  end

  def term= term
    @query += term + ' '
  end

  def term
    strip_filters(query)
  end

  def title= title
    title.to_s.split.map(&:strip).each do |t|
      @query += "title:#{t}" + ' '
    end
  end

  def title
    filters.select { |filter| filter.first == 'title' }.map(&:last).join(' ')
  end

  def subtitle= subtitle
    subtitle.to_s.split.map(&:strip).each do |s|
      @query += "subtitle:#{s}" + ' '
    end
  end

  def subtitle
    filters.select { |filter| filter.first == 'subtitle' }.map(&:last).join(' ')
  end

  private

  def filters
    return @filters if defined?(@filters)

    @filters = query
               .scan(Search::FILTER_REGEX)
               .map(&:first)
               .map { |filter| filter.split(':') }
               .select { |filter| Search::VALID_FILTERS.include?(filter.first) }

    @filters
  end

  def strip_filters query
    filters = query.scan(Search::FILTER_REGEX).map(&:first)

    filters.inject(query) { |q, match| q.sub(match, '') }.strip
  end
end
