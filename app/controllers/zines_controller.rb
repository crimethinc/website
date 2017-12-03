class ZinesController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"
    @title   = "Zines"

    @featured_products = Book.zine.order(published_at: :desc).published.where.not(buy_url: "")
    @products          = Book.zine.order(published_at: :desc).published.where(buy_url: "")

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
