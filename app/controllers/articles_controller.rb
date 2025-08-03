class ArticlesController < ApplicationController
  skip_before_action :check_for_redirection, only: :index

  before_action :set_page_number,               only: :index
  before_action :redirect_malformed_pagination, only: :index
  before_action :force_2025_theme_for_feeds,    only: :index

  def index
    # TEMP: copied from home#index because the route /page/:page changed
    #       from home#index in 2017 theme
    #       to articles#index in 2025 theme
    if Current.theme == '2017'

      @body_id = 'home'
      @homepage = true

      articles_for_current_page = Article.includes(:categories).english.live.published.root

      # Homepage featured article
      @latest_article = articles_for_current_page.first if params[:page].blank?

      # Feed artciles
      @articles = articles_for_current_page.page(params[:page]).per(6)

      render "#{Current.theme}/home/index"
    end

    return unless Current.theme == '2025'

    @articles = Article.includes(:tags, :categories)
                       .for_index(**filters)
                       .root
                       .page(@page_number)
                       .per(15)

    locale = Locale.find_by(abbreviation: params[:lang])
    @lang = locale.abbreviation if locale.present?

    render "#{Current.theme}/articles/index"
  end

  def filters
    {}.merge(sort)
      .merge(language_filter)
      .compact
  end

  def sort
    { fallback_sort: { published_at: :desc } }
  end

  def language_filter
    { fallback_locale: filter_params[:lang].presence&.to_s }
  end

  def filter_params
    params.permit(:lang, :format)
  end

  def show
    @body_id = 'article'

    # get the article
    if request.path.starts_with? '/draft'
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
    @title = PageTitle.new @article.name

    @live_blog = @article.collection_root?

    @previous_article = Article.previous(@article).first
    @next_article     = Article.next(@article).first
    @editable         = @article

    # TODO: extract to an async background job
    # save view stats
    # rubocop:disable Rails/SkipsModelValidations
    Article.increment_counter(:page_views, @article.id) unless signed_in?
    # rubocop:enable Rails/SkipsModelValidations

    if @article.content_in_html?
      render html: @article.content.html_safe, layout: false
    else
      respond_to do |format|
        format.html     { render "#{Current.theme}/articles/show" }
        format.markdown { render "#{Current.theme}/articles/show" }
        format.docx     { download_docx }
      end
    end
  end

  private

  def download_docx
    send_data generate_docx, filename: "#{@article.slug}.docx", type: docx_mimetype
  end

  def generate_docx
    PandocRuby.new(content_without_embeds, from: :markdown, to: :docx).convert
  end

  def content_without_embeds
    @article
      .content_and_notes
      .gsub(/\[\[.+\]\]/, '')
      .gsub("\r\n\r\n\r\n\r\n", "\r\n\r\n")
      .gsub("\r\n\r\n\r\n", "\r\n\r\n")
  end

  def docx_mimetype
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  end

  def set_page_number
    return if params[:page].blank?

    @page_number = params[:page].gsub(/\D/, '')
  end

  def redirect_malformed_pagination
    return if params[:format].in? %w[json atom]
    return if @page_number == params[:page]

    redirect_to [:articles, { page: @page_number }]
  end

  def force_2025_theme_for_feeds
    Current.theme = '2025' if params[:format].in? %w[json atom]
  end
end
