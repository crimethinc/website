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
    @last_modified  = @latest_article&.updated_at || Time.current
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
    @books                  = Book.published.live
    @books_last_modified    = @books.unscoped.order(id: :asc).first.updated_at
    # logos
    @logos                  = Logo.published.live
    @logos_last_modified    = @logos.unscoped.order(id: :asc).first.updated_at
    # posters
    @posters                = Poster.published.live
    @posters_last_modified  = @posters.unscoped.order(id: :asc).first.updated_at
    # stickers
    @stickers               = Sticker.published.live
    @stickers_last_modified = @stickers.unscoped.order(id: :asc).first.updated_at
    # videos
    @videos                 = Video.published.live
    @videos_last_modified   = @videos.unscoped.order(id: :asc).first.updated_at
    # zines
    @zines                  = Zine.published.live
    @zines_last_modified    = @zines.unscoped.order(id: :asc).first.updated_at
    # journals / issues
    @journals               = Journal.published.live
    @journals_last_modified = @journals.unscoped.order(id: :asc).first.updated_at
    @issues                 = Issue.published.live
    @issues_last_modified   = @issues.unscoped.order(id: :asc).first.updated_at
    # podcasts / episodes
    @podcasts               = Podcast.published.live
    @podcasts_last_modified = @podcasts.unscoped.order(id: :asc).first.updated_at
    @episodes               = Episode.published.live
    @episodes_last_modified = @episodes.unscoped.order(id: :asc).first.updated_at

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
end
