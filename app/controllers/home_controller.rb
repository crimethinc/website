class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @homepage = true

    articles_for_current_page = Article.includes(:categories).english.live.published.root

    # Homepage featured article
    @top_article = articles_for_current_page.first if first_page?

    # Feed artciles
    @articles = articles_for_current_page.page(params[:page]).per(6).padding(1)

    render "#{Theme.name}/home/index"
  end

  private

  def first_page?
    params[:page].blank?
  end
end
