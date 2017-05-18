class SearchController < ApplicationController
  def index
    @html_id    = "page"
    @body_id    = "search"
    @page_title = "Search"

    @search  = Search.new(params[:q])
    @results = @search.perform.page(params[:page]).per(15)
  end
end
