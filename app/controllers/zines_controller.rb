class ZinesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'zines'
    @title   = title_for :zines

    zines = Zine.order(published_at: :desc).live.published

    @featured_tools = zines.where.not(buy_url: nil)
    @tools          = zines.where(buy_url: nil)

    render 'tools/index'
  end

  def show
    # Treat a Zine as a Book
    @book = Zine.live.published.where(slug: params[:slug]).first
    return redirect_to [:zines] if @book.blank?

    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'zines'

    @title    = title_for :zines, @book.name
    @editable = @book

    # Use the Book view
    render 'books/show'
  end
end
