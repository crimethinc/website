class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @homepage = true

    articles_for_current_page = Article.includes(:categories).english.live.published.root

    # Homepage featured article
    @latest_article = articles_for_current_page.first if first_page?

    if Current.theme == '2020'
      # Feed artciles, needed for pagination
      @articles = articles_for_current_page.page(params[:page]).per(14).padding(1)

      # Recent article
      @just_published_articles = @articles[0..3]

      # Previous article
      @recent_articles = @articles[4..15]

      # Latest and recent podcast episodes
      podcast_episodes = Episode.live.limit(5)
      @latest_episode  = podcast_episodes.first
      @recent_episodes = podcast_episodes[1..4]

      # Featured books
      @featured_books = Book.published.featured.limit(2).order(featured_at: :desc)

      # Selected tools
      @selected_tools = [
        Sticker.published.featured.limit(4),
        Poster.published.featured.limit(4),
        Zine.published.featured.limit(4),
        Issue.published.featured.limit(4)
      ].flatten

      # Four most recently featured selected tools
      @selected_tools = @selected_tools.sort_by(&:featured_at).reverse[0..3]

      # Ex-Workers’ Collection
      @ex_workers_collection = Article.featured
    else
      # Feed artciles
      @articles = articles_for_current_page.page(params[:page]).per(6).padding(1)
    end

    render "#{Current.theme}/home/index"
  end

  private

  def first_page?
    params[:page].blank?
  end
end
