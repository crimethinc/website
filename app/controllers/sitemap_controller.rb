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
    @articles = live_published_articles

    # articles by year
    @article_years = (1996..Time.zone.today.year).to_a

    # static-ish pages
    @static_paths = STATIC_PATHS

    # To Change Everything (TCE)
    @to_change_everything_languages = TO_CHANGE_EVERYTHING_LANGUAGES

    # languages
    @locales = languages

    # tools
    # books
    @books = Book.published.live

    # logos
    @logos = Logo.published.live

    # posters
    @posters = Poster.published.live

    # stickers
    @stickers = Sticker.published.live

    # videos
    @videos = Video.published.live

    # zines
    @zines = Zine.published.live

    # journals / issues
    @journals = Journal.published.live
    @issues   = Issue.published.live

    # podcasts / episodes
    @podcasts = Podcast.published.live
    @episodes = Episode.published.live

    # TODO: add @TOOL_latest_modified to each tool, used in view for lastmod: in url tag partial
    # TODO: add contradictionary definitions pages to sitemap
    # TODO: add tags index and show pages to sitemap
    # TODO: add steal-something-from-work-day localized pages
  end

  private

  def sitemap_url = Data.define(:loc, :lastmod)

  # languages
  def languages
    Locale.live.each do |locale|
      unicode_url = language_url locale: locale.name.downcase.tr(' ', '-')
      slug_url    = language_url locale: locale.slug.to_sym
      english_url = language_url locale: locale.name_in_english.downcase.tr(' ', '-')

      [unicode_url, slug_url, english_url].uniq
    end
  end

  def live_published_articles
    Rails.cache.fetch([:sitemap, @latest_article, :live_published_articles], expires_in: 12.hours) do
      Article.live
             .published
             .select(:id, :updated_at, :draft_code, :published_at, :publication_status, :slug)
    end
  end

  def add_tools
    # tools (everything except articles)
    tool_classes = [
      Episode,
      Podcast
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
end
