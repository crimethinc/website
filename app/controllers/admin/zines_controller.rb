class Admin::ZinesController < Admin::AdminController
  before_action :authorize
  before_action :set_zine, only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]

  # /admin/zines
  def index
    @books = Book.zine.page(params[:page])
    @title = admin_title
    render "admin/books/index"
  end

  # /admin/zines/1
  def show
    return redirect_to([nil, "admin", "books", @book.id].join("/")) if @book.book?

    @title = admin_title(@book, [:title, :subtitle])
    render "admin/books/show"
  end

  # /admin/zines/new
  def new
    @book = Book.new(zine: true)
    @title = admin_title
    render "admin/books/new"
  end

  # /admin/zines/1/edit
  def edit
    return redirect_to([nil, "admin", "books", @book.id, "edit"].join("/")) if @book.book?

    @title = admin_title(@book, [:id, :title, :subtitle])
    render "admin/books/edit"
  end

  # /admin/zines
  def create
    @book      = Book.new(zine_params)
    @book.zine = true

    if @book.save
      redirect_to [:admin, @book], notice: "Zine was successfully created."
    else
      render :new
    end
  end

  # /admin/zines/1
  def update
    if @book.update(zine_params)
      redirect_to [:admin, @book], notice: "Zine was successfully updated."
    else
      render :edit
    end
  end

  # /admin/zines/1
  def destroy
    @book.destroy
    redirect_to [:admin, :zines], notice: "Zine was successfully destroyed."
  end

  private

  def set_zine
    @book = Book.find(params[:id])
  end

  def set_publication_type
    @publication_type = "zine"
  end

  def zine_params
    params.require(:book).permit(:title, :subtitle, :content, :tweet, :summary,
      :description, :buy_url, :buy_info, :content_format, :slug, :series, :published_at,
      :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
      :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
      :binding_style, :table_of_contents, :zine, :back_image_present,
      :read_download_present, :print_download_present, :lite_download_present)
  end
end
