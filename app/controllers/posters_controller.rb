class PostersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "posters"
    @title    = "Posters"
    @featured_products = Poster.poster.order("published_at desc").all.map{ |x| x if     x.buy_url.present? }.compact
    @products          = Poster.poster.order("published_at desc").all.map{ |x| x unless x.buy_url.present? }.compact

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
