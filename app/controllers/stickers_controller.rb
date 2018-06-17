class StickersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'stickers'
    @title    = 'Stickers'
    @featured_products = Poster.sticker.order(published_at: :desc).published.map { |x| x if x.buy_url.present? }.compact
    @products          = Poster.sticker.order(published_at: :desc).published.map { |x| x if x.buy_url.blank? }.compact

    render 'products/index'
  end

  def show
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'stickers'
    @product = Poster.sticker.where(slug: params[:slug])

    if @product.present?
      @product = @product.first
    else
      return redirect_to [:stickers]
    end

    @title = "Stickers : #{@product.name}"

    @editable = @product

    render 'products/show'
  end
end
