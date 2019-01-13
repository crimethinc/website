class StickersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'stickers'
    @title    = 'Stickers'

    stickers = Sticker.order(published_at: :desc).live.published

    @featured_products = stickers.where.not(buy_url: nil)
    @products          = stickers.where(buy_url: nil)

    render 'products/index'
  end

  def show
    @product = Sticker.published.live.where(slug: params[:slug])
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
