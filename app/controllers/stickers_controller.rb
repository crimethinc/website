class StickersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'stickers'
    @title    = 'Stickers'
    @featured_products = Poster.sticker.order(published_at: :desc).published.live.map { |x| x if x.buy_url.present? }.compact
    @products          = Poster.sticker.order(published_at: :desc).published.live.map { |x| x if x.buy_url.blank? }.compact

    render 'products/index'
  end

  def show
    @product = Poster.sticker.published.live.where(slug: params[:slug])
    return redirect_to [:stickers] if @product.blank?

    @product = @product.first
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'stickers'

    @title = "Stickers : #{@product.name}"
    @editable = @product

    render 'products/show'
  end
end
