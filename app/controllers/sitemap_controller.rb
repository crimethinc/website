class SitemapController < ApplicationController
  def show
    @latest_article = Article.published.english.first
    @last_modified  = @latest_article.updated_at
    @urls           = []

    add_feeds
    add_localized_feeds
    add_categories
    add_articles
    add_article_years
    add_pages
    add_tools
    add_to_change_everything
  end

  private

  def sitemap_url = Data.define(:loc, :lastmod)

  def add_feeds
    # Atom feeds discovery page, for all languages with articles
    @urls << sitemap_url.new(feeds_url, @last_modified)
  end

  def add_localized_feeds
    # articles feed, for all languages with articles
    Locale.unscoped.order(name_in_english: :asc).each do |locale|
      latest_article = Article.published.where(locale: locale.abbreviation).order(updated_at: :desc).select(:updated_at)
      lastmod        = latest_article.blank? ? @last_modified : latest_article.first.updated_at

      # Atom feed
      @urls << sitemap_url.new(json_feed_url(locale.abbreviation), lastmod)

      # JSON feed (https://jsonfeed.org)
      @urls << sitemap_url.new(feed_url(locale.abbreviation), lastmod)
    end
  end

  def add_categories
    # categories
    @urls << sitemap_url.new(categories_url, @last_modified)
    Category.find_each do |category|
      # category feeds
      @urls << sitemap_url.new(category_feed_url(category.slug), @last_modified)

      # category pages
      @urls << sitemap_url.new(category_url(category.slug), @last_modified)
    end
  end

  def add_articles
    # articles
    Article.live.published.find_each do |article|
      url = [root_url, article.path].join
      @urls << sitemap_url.new(url, article.updated_at)
    end
  end

  def add_article_years
    # articles year list page
    (1996..Time.zone.today.year).to_a.each do |year|
      url = [root_url, year].join '/'
      @urls << sitemap_url.new(url, @last_modified)
    end
  end

  def add_pages
    # pages
    static_paths = %w[
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
    ]

    static_paths.each do |path|
      url = [root_url, path].join '/'
      @urls << sitemap_url.new(url, @last_modified)
    end
  end

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

  def add_to_change_everything
    # To Change Everything
    url = [root_url, :tce].join '/'
    @urls << sitemap_url.new(url, @last_modified)

    to_change_everything_languages = [
      # in YAML files
      ToChangeEverythingController::TO_CHANGE_ANYTHING_YAMLS.dup,
      # in /public folder
      %w[czech deutsch polski slovenscina slovensko]
    ].flatten

    to_change_everything_languages.each do |tce_language|
      url = [root_url, :tce, tce_language].join '/'
      @urls << sitemap_url.new(url, @last_modified)

      get_url = [root_url, :tce, tce_language, :get].join '/'
      @urls << sitemap_url.new(get_url, @last_modified)
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
