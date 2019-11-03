class ArticlesController < ApplicationController
  skip_before_action :check_for_redirection, only: :index

  def index
    @articles = Article.includes(:tags, :categories).live.published.root.page(params[:page]).per(10)
  end

  def show
    @body_id = 'article'

    # get the article
    if %r{^/drafts}.match?(request.path)
      @article = Article.find_by(draft_code: params[:draft_code])

      return redirect_to(@article.path) if @article&.published?

      @collection_posts = @article.collection_posts.chronological if @article.present?
    else
      @article = Article.live
                        .where(year:  params[:year])
                        .where(month: params[:month])
                        .where(slug:  params[:slug]).first

      @collection_posts = @article.collection_posts.published.live.chronological if @article.present?
    end

    # no article found, go to /articles feed
    return redirect_to root_path if @article.blank?

    # redirect from draft URL to proper URL
    return redirect_to @article.path if @article.published? && params[:draft_code].present?

    # redirect to parent article, never show nested articles directly
    return redirect_to Article.find(@article.collection_id).path if @article.collection_id.present?

    # redirect to proper URL, chomping /feed off of the end
    return redirect_to @article.path if request.path.ends_with? '/feed'

    # Page title
    @title = PageTitle.new text: @article.name

    @live_blog = @article.collection_root?

    @previous_article = Article.previous(@article).first
    @next_article     = Article.next(@article).first
    @editable         = @article

    # save view stats
    Article.increment_counter(:page_views, @article.id) unless signed_in?

    render html: @article.content.html_safe, layout: false if @article.content_in_html?
  end
end
