class PostersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "posters"
    @products = Poster.poster.all

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "tools"
    @type    = "posters"

    render "products/show"
  end
end
