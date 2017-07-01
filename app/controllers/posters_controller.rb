class PostersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "posters"
    @products = Poster.poster.all
    @title    = "Posters"

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "posters"
    @product = Poster.poster.find_by(slug: params[:slug])
    @title   = "Posters : #{@product.name}"

    render "products/show"
  end
end
