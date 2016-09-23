class PagesController < ApplicationController
  def show
    @article = Article.page.find_by(page_path: params[:path])
    render "articles/show"
  end
end
