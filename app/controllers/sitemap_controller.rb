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

  before_action :set_all_data

  def sitemap_xml;  end
  def sitemap_text; end

  private

  def set_all_data
    set_latest_article
    set_last_modified

    # articles feed, for all languages with articles
    set_localized_feeds

    # categories
    set_categories

    # tags
    set_tags

    # articles
    set_articles

    # articles by year
    set_article_years

    # static-ish pages
    set_static_paths

    # To Change Everything (TCE)
    set_to_change_everything_languages

    # Steal Something from Work Day (SSfWD)
    set_steal_something_from_work_day_urls

    # languages
    set_locales

    # tools
    # books
    set_books
    set_books_last_modified
    # contradictionary definitions
    set_definitions
    set_definitions_last_modified
    # logos
    set_logos
    set_logos_last_modified
    # posters
    set_posters
    set_posters_last_modified
    # stickers
    set_stickers
    set_stickers_last_modified
    # videos
    set_videos
    set_videos_last_modified
    # zines
    set_zines
    set_zines_last_modified
    # journals / issues
    set_journals
    set_journals_last_modified
    set_issues
    set_issues_last_modified
    # podcasts / episodes
    set_podcasts
    set_podcasts_last_modified
    set_episodes
    set_episodes_last_modified
  end

  def set_latest_article
    @latest_article = Article.published.english.first
  end

  def set_last_modified
    @last_modified  = @latest_article&.updated_at || Time.current
  end

  # articles feed, for all languages with articles
  def set_localized_feeds
    @localized_feeds = Locale.unscoped.order(name_in_english: :asc)
  end

  def set_categories
    @categories = Category.all
  end

  def set_tags
    @tags = Tag.all
  end

  def set_articles
    @articles =
      Rails.cache.fetch([:sitemap, @latest_article, :live_published_articles], expires_in: 12.hours) do
        Article.live.published.select(:id, :updated_at, :draft_code, :published_at, :publication_status, :slug)
      end
  end

  def set_article_years
    @article_years = (1996..Time.zone.today.year).to_a
  end

  def set_static_paths
    @static_paths = STATIC_PATHS
  end

  def set_to_change_everything_languages
    @to_change_everything_languages = TO_CHANGE_EVERYTHING_LANGUAGES
  end

  def set_steal_something_from_work_day_urls
    @steal_something_from_work_day_urls = [steal_something_from_work_day_url]

    ssfwd_locales = StealSomethingFromWorkDayController::STEAL_SOMETHING_FROM_WORK_DAY_LOCALES.keys - [:en]

    ssfwd_locales.each do |ssfwd_locale|
      @steal_something_from_work_day_urls << steal_something_from_work_day_url
                                             .sub('http://',  "http://#{ssfwd_locale}.")
                                             .sub('https://', "https://#{ssfwd_locale}.")
    end
  end

  def set_locales
    @locales = Locale.live.each do |locale|
      unicode_url = language_url locale: locale.name.downcase.tr(' ', '-')
      slug_url    = language_url locale: locale.slug.to_sym
      english_url = language_url locale: locale.name_in_english.downcase.tr(' ', '-')

      [unicode_url, slug_url, english_url].uniq
    end
  end

  def set_books
    @books = Book.published.live
  end

  def set_books_last_modified
    @books_last_modified = @books.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_logos
    @logos = Logo.published.live
  end

  def set_logos_last_modified
    @logos_last_modified = @logos.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_posters
    @posters = Poster.published.live
  end

  def set_posters_last_modified
    @posters_last_modified = @posters.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_stickers
    @stickers = Sticker.published.live
  end

  def set_stickers_last_modified
    @stickers_last_modified = @stickers.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_videos
    @videos = Video.published.live
  end

  def set_videos_last_modified
    @videos_last_modified = @videos.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_zines
    @zines = Zine.published.live
  end

  def set_zines_last_modified
    @zines_last_modified = @zines.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_journals
    @journals = Journal.published.live
  end

  def set_journals_last_modified
    @journals_last_modified = @journals.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_issues
    @issues = Issue.published.live
  end

  def set_issues_last_modified
    @issues_last_modified = @issues.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_podcasts
    @podcasts = Podcast.published.live
  end

  def set_podcasts_last_modified
    @podcasts_last_modified = @podcasts.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_episodes
    @episodes = Episode.published.live
  end

  def set_episodes_last_modified
    @episodes_last_modified = @episodes.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end

  def set_definitions
    @definitions = Definition.live.published.group_by(&:filed_under)
  end

  def set_definitions_last_modified
    @definitions_last_modified = Definition.unscoped.order(updated_at: :asc).first&.updated_at || Time.current
  end
end
