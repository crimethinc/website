class Archive
  extend Forwardable
  include Enumerable

  delegate [:current_page, :total_pages, :limit_value] => :articles

  attr_reader :day, :month, :page, :year

  def initialize(year:, month:, day: nil, page: 1)
    @year  = year
    @month = month
    @page  = page
  end

  def articles
    return @articles if defined?(@articles)

    @articles = Article.published.root.all

    @articles = @articles.where(year:  year)  if year.present?
    @articles = @articles.where(month: month) if month.present?
    @articles = @articles.where(day:   day)   if day.present?

    @articles = @articles.page(page).per(15)
  end

  def calendar
    return @calendar if defined?(@calendar)

    @calendar = {}
    articles.each do |article|
      year  = article.published_at.year
      month = article.published_at.month

      @calendar[year]        = {} if @calendar[year].nil?
      @calendar[year][month] = [] if @calendar[year][month].nil?

      @calendar[year][month] << article
    end

    @calendar
  end

  def paginator
    @paginator ||= ArchivePaginator.new(self)
  end

  def each(&block)
    calendar.sort.reverse.each(&block)
  end
end
