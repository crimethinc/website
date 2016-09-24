class PagesController < ApplicationController
  def show
    @article = Article.page.find_by(page_path: params[:path])

    # no layout
    if @article.hide_layout?
      render text: @article.content, layout: false
    else
      render "articles/show"
    end
  end
end
