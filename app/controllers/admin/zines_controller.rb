class Admin::ZinesController < Admin::AdminController
  before_action :authorize
  before_action :set_zine, only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]
  before_action :set_ebook_formats,    only: [:edit, :new]

  def index
    @books = Book.zine.order(slug: :asc).page(params[:page])
    @title = admin_title
    render 'admin/books/index'
  end

  def show
    return redirect_to([nil, 'admin', 'books', @book.id].join('/')) if @book.book?

    @title = admin_title(@book, [:title, :subtitle])
    render 'admin/books/show'
  end

  def new
    @book = Book.new(zine: true)
    @title = admin_title
    render 'admin/books/new'
  end

  def edit
    return redirect_to([nil, 'admin', 'books', @book.id, 'edit'].join('/')) if @book.book?

    @title = admin_title(@book, [:id, :title, :subtitle])
    render 'admin/books/edit'
  end

  def create
    @book      = Book.new(book_params)
    @book.zine = true

    if @book.save
      redirect_to [:admin, @book], notice: 'Zine was successfully created.'
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to [:admin, @book], notice: 'Zine was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Handled by admin/books#destroy
  end

  private

  def set_zine
    @book = Book.find(params[:id])
  end

  def set_publication_type
    @publication_type = 'zine'
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
      :binding_style, :table_of_contents, :zine, :back_image_present,
      :lite_download_present, :epub_download_present, :mobi_download_present,
      :print_black_and_white_a4_download_present, :print_color_a4_download_present,
      :print_color_download_present, :print_black_and_white_download_present,
      :screen_single_page_view_download_present, :screen_two_page_view_download_present)
  end
end
