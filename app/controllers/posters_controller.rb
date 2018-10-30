class PostersController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'
    @title   = title_for :posters

    @featured_products = Poster.poster.order(published_at: :desc).live.published.map { |x| x if x.buy_url.present? }.compact
    @products          = Poster.poster.order(published_at: :desc).live.published.map { |x| x if x.buy_url.blank? }.compact

    render 'products/index'
  end

  def show
    @product = Poster.poster.live.published.where(slug: params[:slug]).first
    return redirect_to [:posters] if @product.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'

    @title    = title_for :posters, @product.name
    @editable = @product

    render 'products/show'
  end
end
