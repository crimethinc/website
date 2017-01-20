class CategoriesController < ApplicationController

  def show
    slug = params[:slug].gsub("_", "-")

    if slug != params[:slug]
      return redirect_to category_path(slug)
    end

    @category = Category.find_by!(slug: slug)
    @articles = @category.articles.live.published.page(params[:page]).per(15)

    if @articles.empty?
      return redirect_to root_path
    end

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
