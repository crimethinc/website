class SearchController < ApplicationController
  def index
    if params[:q].present?
      return redirect_to "https://duckduckgo.com/?q=site%3Acrimethinc.com+#{search_params[:q]}",
                         allow_other_host: true
    end

    @html_id = 'page'
    @body_id = 'search'

    @title = PageTitle.new title_for :search

    render "#{Current.theme}/search/index"
  end

  private

  def search_params
    params.permit(:q)
  end
end
