class Admin::ArticlesController < Admin::AdminController
  before_action :authorize
  before_action :set_article,              only: [:show, :edit, :update, :destroy]
  before_action :set_contribution_options, only: [:new, :edit]
  after_action  :organize_article,         only: [:create, :update]

  # /admin/articles
  def index
    @articles = Article.root.includes(:collection_posts).page(params[:page])
  end

  # /admin/articles/1
  def show
    # TODO this is a hack
    if @article.collection_id.present?
      @collection = Article.find(@article.collection_id)
    end
  end

  # /admin/articles/new
  def new
    @collection = Article.find(params[:id]) if params[:id]
    @article = Article.new
  end

  # /admin/articles/1/edit
  def edit
    @collection = Article.find(@article.collection_id) if @article.in_collection?
  end

  # /admin/articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:admin, @article], notice: "Article was successfully created."
    else
      render :new
    end
  end

  # /admin/articles/1
  def update
    if @article.update(article_params)
      redirect_to [:admin, @article], notice: "Article was successfully updated."
    else
      set_contribution_options
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

  def organize_article
    tag_assigner = TagAssigner.parse_glob(params[:tags])
    tag_assigner.assign_tags_to!(@article)

    @article.save_categories!(params[:categories])
  end

  def article_params
    params.require(:article).permit(:title, :subtitle, :content, :content_format,
                                    :year, :month, :day, :download_url, :tweet,
                                    :slug, :draft_code, :status_id, :summary,
                                    :published_at, :tags, :categories,
                                    :image, :image_description, :css, :hide_layout,
                                    :header_background_color, :header_text_color,
									                  :short_path,
                                    :collection_id,
                                    contributions_attributes: [
                                      :id, :contributor_id, :role_id,:_destroy
                                    ])
  end
end
