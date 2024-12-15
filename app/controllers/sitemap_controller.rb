class SitemapController < ApplicationController
  def show
    @latest_article = Article.published.english.first
    @last_modified  = @latest_article.updated_at
    @urls           = []

    # articles feed, for all languages with articles
    @localized_feeds = Locale.unscoped.order(name_in_english: :asc)

    # categories
    @categories = Category.all

    # articles
    @articles = Article.live.published

    add_article_years
    add_pages
    add_tools
    add_to_change_everything
  end

  private

  def sitemap_url = Data.define(:loc, :lastmod)

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
