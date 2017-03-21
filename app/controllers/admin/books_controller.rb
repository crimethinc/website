class Admin::BooksController < Admin::AdminController
  before_action :authorize
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # /admin/books
  def index
    @books = Book.page(params[:page])
    @title = admin_title
  end

  # /admin/books/1
  def show
    @title = admin_title(@book, [:title, :subtitle])
  end

  # /admin/books/new
  def new
    @book = Book.new
    @title = admin_title
  end

  # /admin/books/1/edit
  def edit
    @title = admin_title(@book, [:id, :title, :subtitle])
  end

  # /admin/books
  def create
    @book = Book.new(book_params)

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
    @book.destroy
    redirect_to [:admin, :books], notice: "Book was successfully destroyed."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :subtitle, :description, :content,
      :slug, :download_url, :price_in_cents, :tweet, :summary, :pages,
      :height, :width, :depth, :weight, :words, :illustrations, :photographs,
      :cover_style, :binding_style, :table_of_contents, :buy_url)
  end
end
