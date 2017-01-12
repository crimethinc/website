class CategoriesController < ApplicationController

  def show
    @category = Category.find_by!(slug: params["slug"])
    @articles = @category.articles

    @html_id  = "page"
    @body_id  = "category"
    @title    = @category.name
  end

end
