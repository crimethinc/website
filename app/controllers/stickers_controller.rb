class StickersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "stickers"
    @title    = "Stickers"
    @products = Poster.sticker.order("published_at desc").page(params[:page]).per(100)

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "stickers"
    @product = Poster.sticker.find_by(slug: params[:slug])
    @title   = "Stickers : #{@product.name}"

    render "products/show"
  end
end
