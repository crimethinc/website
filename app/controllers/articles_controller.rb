class ArticlesController < ApplicationController
  def index
    @slug       = "articles"
    @page_title = "Articles"

    @articles_year  = params[:year]
    @articles_month = params[:month]
    @articles_day   = params[:day]

    @articles = Article.published.all
    #TODO add this after pagination setup:
    # .paginate(per_page: 5, page: params[:page])

    @articles = @articles.where(year:  params[:year])  if params[:year]
    @articles = @articles.where(month: params[:month]) if params[:month]
    @articles = @articles.where(day:   params[:day])   if params[:day]

    if @articles.length == 1
      return redirect_to @articles.first.path
    end
  end

  def show
    @slug = "article"

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
    if @article.nil?
      return redirect_to articles_path
    else
      @title = @article.name
    end

    if @article.hide_layout?
      render text: @article.content, layout: false
    else
      render "articles/show"
    end
  end
end
