class Admin::ArticlesController < Admin::AdminController
  before_action :authorize
  before_action :set_article,      only: [:show, :edit, :update, :destroy]
  after_action  :organize_article, only: [:create, :update]

  # # /admin/articles
  def index
    @articles = Article.all
  end

  # /admin/articles/1
  def show
  end

  # /admin/articles/new
  def new
    @article = Article.new
  end

  # /admin/articles/1/edit
  def edit
  end

  # /admin/articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:admin, @article], notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  # /admin/articles/1
  def update
    if @article.update(article_params)
      redirect_to [:admin, @article], notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  # /admin/articles/1
  def destroy
    @article.destroy
    redirect_to [:admin, :articles], notice: 'Article was successfully destroyed.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def organize_article
    @article.save_tags!(params[:tags])
    @article.save_categories!(params[:categories])
  end

  def article_params
    params.require(:article).permit(:title, :subtitle, :content,
                                    :year, :month, :day,
                                    :slug, :code, :status, :published_at,
                                    :page_path, :page, :tags, :categories,
                                    :image, :image_description, :css,
                                    :pinned_to_top, :pinned_to_bottom,
                                    :hide_header, :hide_footer, :hide_layout)
  end
end
