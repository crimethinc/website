class PostersController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'
    @title   = title_for :posters

    posters = Poster.order(published_at: :desc).live.published

    @featured_products = posters.where.not(buy_url: nil)
    @products          = posters.where(buy_url: nil)

    render 'products/index'
  end

  def show
    @product = Poster.live.published.where(slug: params[:slug]).first
    return redirect_to [:posters] if @product.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'posters'

    @title    = title_for :posters, @product.name
    @editable = @product

    render 'products/show'
  end
end
