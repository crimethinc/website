class ArchivesController < ApplicationController
  def home
    @slug = "home"

    # feed
    @articles = Article.unpinned.published.feed.limit(5).all

    # pinned articles
    @pinned_to_top    = Article.pinned_to_top.first
    @pinned_to_bottom = Article.pinned_to_bottom.first
  end

  def index
    @slug     = "archives"
    @articles = Article.unpinned.published.feed.all
  end
end
