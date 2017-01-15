class CategoriesController < ApplicationController

  def show
    @category = Category.find_by!(slug: params[:slug])
    @articles = @category.articles.live.published.page(params[:page]).per(15)

    @html_id  = "page"
    @body_id  = "category"
    @title    = @category.name
  end

  def feed
    @category = Category.find_by!(slug: params[:slug])
    @articles = @category.articles.live.published.page(params[:page]).per(25)

    @title    = @category.name

    render "articles/index"
  end

end
