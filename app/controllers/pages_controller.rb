class PagesController < ApplicationController
  def show
    @article = Page.find_by(slug: params[:path])

    # no layout
    if @article.hide_layout?
      render text: @article.content, layout: false
    else
      render "articles/show"
    end
  end
end
