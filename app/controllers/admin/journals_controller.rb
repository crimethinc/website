module Admin
  class JournalsController < Admin::AdminController
    before_action :authorize
    before_action :set_journal,          only: [:show, :edit, :update, :destroy]
    before_action :set_publication_type, only: [:show, :edit, :new, :index]
    before_action :set_ebook_formats,    only: [:edit, :new]

    def index
      @books = Journal.order(slug: :asc).page(params[:page])
      @title = admin_title
      render 'admin/books/index'
    end

    def show
      @title = admin_title(@book, [:title, :subtitle])
      render 'admin/books/show'
    end

    def new
      @book = Journal.new
      @title = admin_title
      render 'admin/books/new'
    end

    def edit
      @title = admin_title(@book, [:id, :title, :subtitle])
      render 'admin/books/edit'
    end

    def create
      @book = Journal.new(journal_params)
      @book.journal = true

      if @book.save
        redirect_to [:admin, @book], notice: 'Journal was successfully created.'
      else
        render :new
      end
    end

    def update
      if @book.update(journal_params)
        redirect_to [:admin, @book], notice: 'Journal was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      redirect_to [:admin, publication_type], notice: "#{publication_type.to_s.capitalize.singularize} was successfully destroyed."
    end

    private

    def set_journal
      @book = Journal.find(params[:id])
    end

    def set_publication_type
      @publication_type = 'journal'
    end

    def set_ebook_formats
      @ebook_formats = Tool::EBOOK_FORMATS
    end

    def journal_params
      params.require(:journal).permit(:title, :subtitle, :content, :tweet, :summary, :status_id,
                                      :description, :buy_url, :buy_info, :content_format, :slug, :series, :published_at,
                                      :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
                                      :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
                                      :binding_style, :table_of_contents, :back_image_present,
                                      :lite_download_present, :epub_download_present, :mobi_download_present,
                                      :print_black_and_white_a4_download_present, :print_color_a4_download_present,
                                      :print_color_download_present, :print_black_and_white_download_present,
                                      :screen_single_page_view_download_present, :screen_two_page_view_download_present,
                                      :publication_status)
    end
  end
end
