class SitemapController < ApplicationController
  STATIC_PATHS = %w[
    about
    arts/submission-guidelines
    books/into-libraries
    books/lit-kit
    contact
    faq
    games/j20
    kickstarter/2017
    library
    start
    steal-something-from-work-day
    store
    tce
    tools
  ].freeze

  TO_CHANGE_EVERYTHING_LANGUAGES = [
    # in YAML files
    ToChangeEverythingController::TO_CHANGE_ANYTHING_YAMLS.dup,
    # in /public folder
    %w[czech deutsch polski slovenscina slovensko]
  ].flatten.freeze

  def show
    @latest_article = Article.published.english.first
    @last_modified  = @latest_article.updated_at
    @urls           = []

    # articles feed, for all languages with articles
    @localized_feeds = Locale.unscoped.order(name_in_english: :asc)

    # categories
    @categories = Category.all

    # articles
    @articles = Article.live
                       .published
                       .select(:id, :updated_at, :draft_code, :published_at, :publication_status, :slug)

    # articles by year
    @article_years = (1996..Time.zone.today.year).to_a

    # static-ish pages
    @static_paths = STATIC_PATHS

    # To Change Everything (TCE)
    @to_change_everything_languages = TO_CHANGE_EVERYTHING_LANGUAGES

    # TODO: extract to show view + _url partial
    add_languages
    add_tools
  end

  private

  def sitemap_url = Data.define(:loc, :lastmod)

  def add_tools
    # tools (everything except articles)
    tool_classes = [
      Book,
      Episode,
      Issue,
      Journal,
      Logo,
      Podcast,
      Poster,
      Sticker,
      Video,
      Zine
    ]

    tool_classes.each do |tool_class|
      # tool list page
      url = [
        root_url,
        tool_class.name.downcase.pluralize
      ].join '/'

      latest = tool_class.order(updated_at: :desc).first
      @urls << sitemap_url.new(url, latest.updated_at)

      # tool pages
      tool_class.published.find_each do |tool|
        url = [root_url, tool.path].join
        @urls << sitemap_url.new(url, tool.updated_at)
      end
    end
  end

  # languages
  def add_languages
    language_url = [root_url, :languages].join '/'
    @urls << sitemap_url.new(language_url, @last_modified)

    Locale.live.each do |locale|
      unicode_url = language_url locale: locale.name.downcase.tr(' ', '-')
      slug_url    = language_url locale: locale.slug.to_sym
      english_url = language_url locale: locale.name_in_english.downcase.tr(' ', '-')

      urls = [unicode_url, slug_url, english_url].uniq

      urls.each do |url|
        @urls << sitemap_url.new(url, @last_modified)
      end
    end
  end
end
