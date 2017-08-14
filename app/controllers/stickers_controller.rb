class StickersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "stickers"
    @title    = "Stickers"
    @featured_products = Poster.sticker.order("published_at desc").all.map{ |x| x if     x.buy_url.present? }.compact
    @products          = Poster.sticker.order("published_at desc").all.map{ |x| x unless x.buy_url.present? }.compact

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "stickers"
    @product = Poster.sticker.find_by(slug: params[:slug])
    @title   = "Stickers : #{@product.name}"

    @editable = @product

    render "products/show"
  end
end
