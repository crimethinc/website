class ArchivesController < ApplicationController
  def home
    @slug = "home"

    # feed
    @articles = Article.published.limit(5).all

    # pinned articles
    # @pinned_to_top    = Article.pinned_to_top.first
    # @pinned_to_bottom = Article.pinned_to_bottom.first
  end

  def index
    @slug     = "archives"
    @articles = {}

    Article.unpinned.published.feed.all.each do |article|
      year  = article.published_at.year
      month = article.published_at.month

      @articles[year]        = {} if @articles[year].nil?
      @articles[year][month] = [] if @articles[year][month].nil?

      @articles[year][month] << article
    end
  end
end
