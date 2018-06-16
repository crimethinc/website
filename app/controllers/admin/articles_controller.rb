class Admin::ArticlesController < Admin::AdminController
  before_action :authorize
  before_action :set_article,      only: [:show, :edit, :update, :destroy]
  before_action :set_published_at, only: [:create, :update]
  before_action :set_statuses,     only: [:new, :edit]
  before_action :set_categories,   only: [:new, :edit]
  after_action  :organize_article, only: [:create, :update]

  def index
    @articles = Article.root.includes(:collection_posts).page(params[:page])
    @title = admin_title
  end

  def show
    # TODO this is a hack
    if @article.collection_id.present?
      @collection = Article.find(@article.collection_id)
    end

    @title = admin_title(@article, [:title, :subtitle])
    @html_id = 'admin-article'
    @body_id = 'top'
  end

  def new
    @collection     = Article.find(params[:id]) if params[:id]
    @article        = Article.new
    @article.status = Status.find_by(name: 'draft')

    @title = admin_title
    @html_id = 'admin-article'
  end

  def edit
    # update_columns to avoid hitting callbacks, namely updating Search index
    @article.update_columns(user_id: current_user)

    @collection = Article.find(@article.collection_id) if @article.in_collection?
    @title = admin_title(@article, [:id, :title, :subtitle])
    @html_id = 'admin-article'
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:admin, @article], notice: 'Article was successfully created.'
    else
      set_statuses
      render :new
    end
  end

  def update
    if @article.update(article_params)
      # update_columns to avoid hitting callbacks, namely updating Search index
      @article.update_columns(user_id: nil)

      redirect_to [:admin, @article], notice: 'Article was successfully updated.'
    else
      set_statuses
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to [:admin, :articles], notice: 'Article was successfully destroyed.'
  end

  private

  def set_article
    if params[:year] && params[:slug]
      @article = Article.where(year: params[:year]).where(month: params[:month]).where(day: params[:day]).where(slug: params[:slug]).first

      return redirect_to([:edit, :admin, @article])
    elsif params[:draft_code].present?
      @article = Article.find_by(draft_code: params[:draft_code])
      return redirect_to([:edit, :admin, @article])
    else
      @article = Article.find(params[:id])
    end
  end

  def set_categories
    @categories = Category.all
  end

  def set_statuses
    @draft     = Status.find_by(name: 'draft')
    @published = Status.find_by(name: 'published')
  end

  def organize_article
    tag_assigner = TagAssigner.parse_glob(params[:tags])
    unless tag_assigner.blank?
      tag_assigner.assign_tags_to!(@article)
    end
  end

  def article_params
    params.require(:article).permit(:title, :subtitle, :content, :content_format,
                                    :year, :month, :day, :download_url, :tweet,
                                    :slug, :draft_code, :status_id, :summary,
                                    :published_at, :tags, :collection_id, :short_path,
                                    :image, :image_description, :css, :hide_layout,
                                    :header_background_color, :header_text_color,
                                    :header_shadow_text, :image_mobile, :published_at_tz,
                                    category_ids: [])
  end
end
