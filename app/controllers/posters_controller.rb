class PostersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "posters"
    @products = Poster.poster.order("published_at desc").page(params[:page]).per(10)
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
