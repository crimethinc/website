class SearchController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "search"

    if params[:q].blank?
      return redirect_to root_path
    end

    @search  = Search.new(params[:q])
    @results = @search.perform.page(params[:page]).per(15)
    @title = "Search results for \"#{@search.query}\""
  end

  def advanced
    @html_id = "page"
    @body_id = "search"
    @title   = "Advanced Search"

    @advanced_search = AdvancedSearch.new(params[:q])
  end

  def advanced_search
    @advanced_search = AdvancedSearch.new
    @advanced_search.update_attributes(params[:advanced_search])

    redirect_to(search_path(q: @advanced_search.query))
  end
end
