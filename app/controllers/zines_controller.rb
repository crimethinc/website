class ZinesController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"
    @title   = "Zines"

    @featured_products = Book.zine.order(published_at: :desc).published.where.not(buy_url: nil)
    @products          = Book.zine.order(published_at: :desc).published.where(buy_url: nil)

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"

    # Treat a Zine as a Book
    @book  = Book.zine.where(slug: params[:slug])

    if @book.present?
      @book = @book.first
    else
      return redirect_to [:zines]
    end

    @title = "Zines : #{@book.name}"

    @editable = @book

    # Use the Book view
    render "books/show"
  end
end
