class HomeController < ApplicationController
  def index
    @body_id = 'home'
    @homepage = true

    # feed
    @top_article = Article.includes(:categories).english.live.published.root.first if first_page?
    @articles    = Article.includes(:categories).english.live.published.root.page(params[:page]).per(6).padding(1)

    render "#{Theme.name}/home/index"
  end

  private

  def first_page?
    params[:page].blank?
  end
end
