class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @homepage = true

    articles_for_current_page = Article.includes(:categories).english.live.published.root

    # Homepage featured article
    @top_article = articles_for_current_page.first if first_page?

    if Theme.name == '2020'
      # Feed artciles, needed for pagination
      @articles = articles_for_current_page.page(params[:page]).per(14).padding(1)

      # Recent article
      @recent_articles = @articles[0..3]

      # Previous article
      @previous_articles = @articles[4..15]

      # Latest and recent podcast episodes
      podcast_episodes         = Episode.live.limit(5)
      @latest_podcast_episode  = podcast_episodes.first
      @recent_podcast_episodes = podcast_episodes[1..4]

      # Latest books
      @latest_books = Book.published.limit(2)
    else
      # Feed artciles
      @articles = articles_for_current_page.page(params[:page]).per(6).padding(1)
    end

    render "#{Theme.name}/home/index"
  end

  private

  def first_page?
    params[:page].blank?
  end
end
