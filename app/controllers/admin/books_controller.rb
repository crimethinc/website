class Admin::BooksController < Admin::AdminController
  before_action :authorize
  before_action :set_book,             only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]
  before_action :set_ebook_formats,    only: [:edit, :new]

  def index
    @books = Book.book.order(slug: :asc).page(params[:page])
    @title = admin_title
  end

  def show
    return redirect_to([nil, 'admin', 'zines', @book.id].join('/')) if @book.zine?

    @title = admin_title(@book, [:title, :subtitle])
  end

  def new
    @book = Book.new
    @title = admin_title
  end

  def edit
    return redirect_to([nil, 'admin', 'zines', @book.id, 'edit'].join('/')) if @book.zine?

    @title = admin_title(@book, [:id, :title, :subtitle])
  end

  def create
    @book = Book.new(book_params)
    publication_type = @book.zine? ? :zines : :books

    if @book.save
      redirect_to [:admin, @book], notice: '#{publication_type.to_s.capitalize.singularize} was successfully created.'
    else
      render :new
    end
  end

  def update
    publication_type = @book.zine? ? :zines : :books
    if @book.update(book_params)
      redirect_to [:admin, @book], notice: '#{publication_type.to_s.capitalize.singularize} was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    publication_type = @book.zine? ? :zines : :books
    @book.destroy
    redirect_to [:admin, publication_type], notice: '#{publication_type.to_s.capitalize.singularize} was successfully destroyed.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_publication_type
    @publication_type = 'book'
  end

  def set_ebook_formats
    @ebook_formats = {
      screen_single_page_view:  ['Screen Single Page View', 'Is there a one page wide <code>PDF</code> for on-screen reading uploaded?'],
      screen_two_page_view:     ['Screen Two Page View',    'Is there a two page wide <code>PDF</code> for on-screen reading uploaded?'],
      print_color:              ['Print Color',             'Is there a color <code>PDF</code> for printing uploaded?'],
      print_black_and_white:    ['Print B/W',               'Is there a B/W <code>PDF</code> for printing uploaded?'],
      print_color_a4:           ['Print Color A4',          'Is there an A4 sized color <code>PDF</code> for printing uploaded?'],
      print_black_and_white_a4: ['Print B/W A4',            'Is there an A4 sized B/W <code>PDF</code> for printing uploaded?'],
      epub:                     ['ePub',                    'Is there a <code>.epub</code> file uploaded?'],
      mobi:                     ['Mobi',                    'Is there a <code>.mobi</code> file uploaded?'],
      lite:                     ['Lo Res',                  'Is there a low resolution or single page view PDF uploaded?'],
    }
  end

  def book_params
    params.require(:book).permit(:title, :subtitle, :content, :tweet, :summary, :status_id,
      :description, :buy_url, :buy_info, :content_format, :slug, :series, :published_at,
      :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
      :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
      :binding_style, :table_of_contents, :zine, :back_image_present, :gallery_images_count,
      :lite_download_present, :epub_download_present, :mobi_download_present,
      :print_black_and_white_a4_download_present, :print_color_a4_download_present,
      :print_color_download_present, :print_black_and_white_download_present,
      :screen_single_page_view_download_present, :screen_two_page_view_download_present)
  end
end

