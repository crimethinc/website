class CategoriesController < ApplicationController

  def show
    @category = Category.find_by!(slug: params[:slug])
    @articles = @category.articles.page(params[:page]).per(15)

    @html_id  = "page"
    @body_id  = "category"
    @title    = @category.name
  end

end
