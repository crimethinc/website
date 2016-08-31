class ArticlesController < ApplicationController
  # /2016/08/
  # /2016/
  # /section
  # /tag
  # /author
  def index
    @articles = Article.all
  end

  # /2016/08/31
  def show
    @article = Article.find_by(year:  params[:year],
                               month: params[:month],
                               day:   params[:day],
                               slug:  params[:slug])
  end
end
