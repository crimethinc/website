class PostersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'posters'
    @title    = 'Posters'
    @featured_products = Poster.poster.order(published_at: :desc).published.map { |x| x if x.buy_url.present? }.compact
    @products          = Poster.poster.order(published_at: :desc).published.map { |x| x if x.buy_url.blank? }.compact

    render 'products/index'
  end

  def show
    @product = Poster.poster.where(slug: params[:slug])
    return redirect_to [:posters] if @product.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'

    @product  = @product.first
    @title    = "Posters : #{@product.name}"
    @editable = @product

    render 'products/show'
  end
end
