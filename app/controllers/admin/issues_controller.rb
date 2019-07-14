module Admin
  class IssuesController < Admin::ToolsController
    before_action :set_journal, only: %i[show edit update destroy]

    def index
      @books = Issue.order(slug: :asc).page(params[:page])
      @title = admin_title
      render 'admin/books/index'
    end

    def show
      @title = admin_title(@book, %i[title subtitle])
      render 'admin/books/show'
    end

    def new
      @book = Issue.new
      @book.journal_id = params[:journal_id]
      @title = admin_title
      render 'admin/books/new'
    end

    def edit
      @title = admin_title(@book, %i[id title subtitle])
      render 'admin/books/edit'
    end

    def create
      @book = Issue.new(journal_params)

      if @book.save
        redirect_to [:admin, @book], notice: 'Issue was successfully created.'
      else
        render :new
      end
    end

    def update
      if @book.update(journal_params)
        redirect_to [:admin, @book], notice: 'Issue was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      redirect_to %i[admin journals], notice: 'Issue was successfully destroyed.'
    end

    private

    def set_journal
      @book = Issue.find(params[:id])
    end

    def journal_params
      params.require(:issue).permit(:title, :subtitle, :content, :tweet, :summary,
                                    :description, :buy_url, :buy_info, :slug, :series, :published_at,
                                    :price_in_cents, :height, :width, :depth, :weight, :pages, :words, :illustrations,
                                    :photographs, :printing, :ink, :definitions, :recipes, :has_index, :cover_style,
                                    :binding_style, :table_of_contents, :back_image_present,
                                    :lite_download_present, :epub_download_present, :mobi_download_present,
                                    :print_black_and_white_a4_download_present, :print_color_a4_download_present,
                                    :print_color_download_present, :print_black_and_white_download_present,
                                    :screen_single_page_view_download_present, :screen_two_page_view_download_present,
                                    :publication_status, :journal_id, :issue)
    end
  end
end
