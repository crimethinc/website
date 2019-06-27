module Admin
  class BooksController < Admin::ToolsController
    before_action :set_book, only: %i[show edit update destroy]

    def index
      @books = Book.order(slug: :asc).page(params[:page])
      @title = admin_title
    end

    def show
      @title = admin_title(@book, %i[title subtitle])
    end

    def new
      @book  = Book.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@book, %i[id title subtitle])
    end

    def create
      @book = Book.new(book_params)

      if @book.save
        redirect_to [:admin, @book], notice: 'Book was successfully created.'
      else
        render :new
      end
    end

    def update
      if @book.update(book_params)
        redirect_to [:admin, @book], notice: 'Book was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      redirect_to %i[admin books], notice: 'Book was successfully destroyed.'
    end

    private

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :subtitle, :content, :tweet, :summary, :publication_status,
                                   :description, :buy_url, :buy_info, :slug, :series, :published_at,
                                   :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
                                   :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
                                   :binding_style, :table_of_contents, :back_image_present, :gallery_images_count,
                                   :lite_download_present, :epub_download_present, :mobi_download_present,
                                   :print_black_and_white_a4_download_present, :print_color_a4_download_present,
                                   :print_color_download_present, :print_black_and_white_download_present,
                                   :screen_single_page_view_download_present, :screen_two_page_view_download_present)
    end
  end
end
