class Archive
  extend Forwardable
  include Enumerable

  delegate [:current_page, :total_pages, :limit_value] => :articles

  attr_reader :articles, :calendar

  def initialize(articles)
    @articles = articles

    @calendar = {}
    articles.each do |article|
      year  = article.published_at.year
      month = article.published_at.month

      @calendar[year]        = {} if @calendar[year].nil?
      @calendar[year][month] = [] if @calendar[year][month].nil?

      @calendar[year][month] << article
    end
  end

  def each(&block)
    calendar.sort.reverse.each(&block)
  end
end
