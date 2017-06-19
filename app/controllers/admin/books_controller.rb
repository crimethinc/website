class Admin::BooksController < Admin::AdminController
  before_action :authorize
  before_action :set_book,             only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]

  # /admin/books
  def index
    @books = Book.book.page(params[:page])
    @title = admin_title
  end

  # /admin/books/1
  def show
    return redirect_to([nil, "admin", "zines", @book.id].join("/")) if @book.zine?

    @title = admin_title(@book, [:title, :subtitle])
  end

  # /admin/books/new
  def new
    @book = Book.new(book: true)
    @title = admin_title
  end

  # /admin/books/1/edit
  def edit
    return redirect_to([nil, "admin", "zines", @book.id, "edit"].join("/")) if @book.zine?

    @title = admin_title(@book, [:id, :title, :subtitle])
  end

  # /admin/books
  def create
    @book      = Book.new(book_params)
    @book.book = true

    if @book.save
      redirect_to [:admin, @book], notice: "Book was successfully created."
    else
      render :new
    end
  end

  # /admin/books/1
  def update
    if @book.update(book_params)
      redirect_to [:admin, @book], notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  # /admin/books/1
  def destroy
    publication_type = @book.zine? ? :zines :  :books
    @book.destroy
    redirect_to [:admin, publication_type], notice: "#{publication_type.to_s.capitalize.singularize} was successfully destroyed."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_publication_type
    @publication_type = "book"
  end

  def book_params
    params.require(:book).permit(:title, :subtitle, :content, :tweet, :summary,
      :description, :buy_url, :buy_info, :content_format, :slug, :series, :published_at,
      :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
      :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
      :binding_style, :table_of_contents, :zine, :back_image_present,
      :read_download_present, :print_download_present, :lite_download_present)
  end
end
