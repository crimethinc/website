class SearchController < ApplicationController
  def index
    redirect_to "https://duckduckgo.com/?q=#{params[:q]}+site%3Acrimethinc.com"
  end
end
