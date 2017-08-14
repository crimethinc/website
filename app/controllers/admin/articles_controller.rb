class Admin::ArticlesController < Admin::AdminController
  before_action :authorize
  before_action :set_article,              only: [:show, :edit, :update, :destroy]
  before_action :set_statuses,             only: [:new, :edit]
  before_action :set_contribution_options, only: [:new, :edit]
  after_action  :organize_article,         only: [:create, :update]

  # /admin/articles
  def index
    @articles = Article.root.includes(:collection_posts).page(params[:page])
    @title = admin_title
  end

  # /admin/articles/1
  def show
    # TODO this is a hack
    if @article.collection_id.present?
      @collection = Article.find(@article.collection_id)
    end

    @title = admin_title(@article, [:title, :subtitle])
    @html_id = "admin-article"
    @body_id = "top"
  end

  # /admin/articles/new
  def new
    @collection = Article.find(params[:id]) if params[:id]
    @article = Article.new
    @article.status = Status.find_by(name: "draft")

    @title = admin_title
    @html_id = "admin-article"
  end

  # /admin/articles/1/edit
  def edit
    @collection = Article.find(@article.collection_id) if @article.in_collection?
    @title = admin_title(@article, [:id, :title, :subtitle])
    @html_id = "admin-article"
  end

  # /admin/articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:admin, @article], notice: "Article was successfully created."
    else
      set_statuses
      render :new
    end
  end

  # /admin/articles/1
  def update
    if @article.update(article_params)
      redirect_to [:admin, @article], notice: "Article was successfully updated."
    else
      set_contribution_options
      set_statuses
      render :edit
    end
  end

  # /admin/articles/1
  def destroy
    @article.destroy
    redirect_to [:admin, :articles], notice: "Article was successfully destroyed."
  end

  private

  def set_article
    if params[:year] && params[:slug]
      @article = Article.where(year:  params[:year]
                       ).where(month: params[:month]
                       ).where(day:   params[:day]
                       ).where(slug:  params[:slug]).first

      return redirect_to([:edit, :admin, @article])
    elsif params[:draft_code].present?
      @article = Article.find_by(draft_code: params[:draft_code])
      return redirect_to([:edit, :admin, @article])
    else
      @article = Article.find(params[:id])
    end
  end

  def set_contribution_options
    @contributors = Contributor.order(:name)
    @roles        = Role.order(:name)
  end

  def set_statuses
    @draft     = Status.find_by(name: "draft")
    @published = Status.find_by(name: "published")
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
                                    :header_shadow_text,
                                    category_ids: [],
                                    contributions_attributes: [
                                      :id, :contributor_id, :role_id,:_destroy
                                    ])
  end
end
