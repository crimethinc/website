class ArticlesController < ApplicationController
  def index
    @articles = Article.live.published.page(params[:page]).per(25)
  end

  def show
    @body_id = "article"

    # get the article
    if request.path =~ /^\/drafts/
      @article = Article.find_by(draft_code: params[:draft_code])

      if @article.published?
        return redirect_to(@article.path)
      end

    else
      @article = Article.where(year:  params[:year]
                       ).where(month: params[:month]
                       ).where(day:   params[:day]
                       ).where(slug:  params[:slug]).first
    end

    # no article found, go to /articles feed
    if @article.blank? || !@article.published?
      return redirect_to root_path
    end

    if @article.published? && params[:draft_code].present?
      return redirect_to @article.path
    end

    @title = @article.name

    @child_articles = @article.articles.published.live.chronological

    if @article.hide_layout?
      render html: @article.content.html_safe, layout: false
    else
      render "articles/show"
    end
  end
end
