class Admin::ArticlesController < Admin::AdminController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

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

  def article_params
    params.require(:article).permit(:title,
                                    :subtitle,
                                    :content,
                                    :year,
                                    :month,
                                    :day,
                                    :slug,
                                    :code,
                                    :status,
                                    :published_at)
  end
end
