class HomeController < ApplicationController
  def index
    @body_id = "home"
    @homepage = true

    # feed
    @top_article = Article.includes(:categories, :status).live.published.root.first if first_page?
    @articles    = Article.includes(:categories, :status).live.published.root.page(params[:page]).per(6).padding(1)
  end

  private

  def first_page?
    !params[:page].present?
  end
end
