class ZinesController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "zines"
    @products = Book.zine.all

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "zines"

    # Treat a Zine as a Book
    @book = Book.zine.find_by(slug: params[:slug])

    # Use the Book view
    render "books/show"
  end
end
