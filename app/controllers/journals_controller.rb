class JournalsController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'journals'
    @title   = title_for :journals

    @featured_products = Journal.order(published_at: :desc).published.where.not(buy_url: nil)
    @products          = Journal.order(published_at: :desc).published.where(buy_url: nil)

    render 'products/index'
  end

  def show
    @book = Journal.where(slug: params[:slug]).first
    return redirect_to [:journals] if @book.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'journals'

    @title    = title_for :journals, @book.name
    @editable = @book

    # Use the Book view
    render 'books/show'
  end
end
