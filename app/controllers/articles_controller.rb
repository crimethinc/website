class ArticlesController < ApplicationController
  skip_before_action :set_social_links, only: :index
  skip_before_action :set_new_subscriber, only: :index
  skip_before_action :set_pinned_pages, only: :index
  skip_before_action :check_for_redirection, only: :index

  def index
    @articles = Article.includes(:tags, :categories, :contributions).live.published.root.page(params[:page]).per(10)
  end

  def show
    @body_id = "article"

    # get the article
    if request.path =~ /^\/drafts/
      @article = Article.find_by(draft_code: params[:draft_code])

      if @article.published?
        return redirect_to(@article.path)
      end

      if @article.present?
        @collection_posts = @article.collection_posts.chronological
      end

    else
      @article = Article.where(year:  params[:year]
                       ).where(month: params[:month]
                       ).where(day:   params[:day]
                       ).where(slug:  params[:slug]).first
      if @article.present?
        @collection_posts = @article.collection_posts.published.live.chronological
      end
    end

    # no article found, go to /articles feed
    if @article.blank? || !@article.published?
      return redirect_to root_path
    end

    if @article.published? && params[:draft_code].present?
      return redirect_to @article.path
    end

    @title = @article.name

    @previous_article = Article.previous(@article).first
    @next_article     = Article.next(@article).first

    if @article.hide_layout?
      render html: @article.content.html_safe, layout: false
    else
      render "articles/show"
    end
  end
end
