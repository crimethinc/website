class ZinesController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"
    @title   = "Zines"

    @featured_products = Book.zine.order(published_at: :desc).all.map{ |x| x if     x.buy_url.present? }.compact
    @products          = Book.zine.order(published_at: :desc).all.map{ |x| x unless x.buy_url.present? }.compact

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"

    # Treat a Zine as a Book
    @book  = Book.zine.find_by(slug: params[:slug])
    @title = "Zines : #{@book.name}"

    @editable = @book

    # Use the Book view
    render "books/show"
  end
end
