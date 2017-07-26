class PostersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "posters"
    @title    = "Posters"
    @products = Poster.poster.order("published_at desc").page(params[:page]).per(100)

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
