class ZinesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'zines'
    @title   = title_for :zines

    @featured_products = Zine.order(published_at: :desc).live.published.where.not(buy_url: nil)
    @products          = Zine.order(published_at: :desc).live.published.where(buy_url: nil)

    render 'products/index'
  end

  def show
    # Treat a Zine as a Book
    @book = Zine.live.published.where(slug: params[:slug]).first
    return redirect_to [:zines] if @book.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'zines'

    @title    = title_for :zines, @book.name
    @editable = @book

    # Use the Book view
    render 'books/show'
  end
end
