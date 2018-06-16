class PostersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'posters'
    @title    = 'Posters'
    @featured_products = Poster.poster.order(published_at: :desc).published.map { |x| x if     x.buy_url.present? }.compact
    @products          = Poster.poster.order(published_at: :desc).published.map { |x| x unless x.buy_url.present? }.compact

    render 'products/index'
  end

  def show
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'
    @product = Poster.poster.where(slug: params[:slug])

    if @product.present?
      @product = @product.first
    else
      return redirect_to [:posters]
    end

    @title = "Posters : #{@product.name}"
    @editable = @product

    render 'products/show'
  end
end
