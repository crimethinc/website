module Admin
  class ZinesController < Admin::ToolsController
    before_action :set_zine, only: %i[show edit update destroy]

    def index
      @books = Zine.order(slug: :asc).page(params[:page])
      @title = admin_title
      render 'admin/books/index'
    end

    def show
      @title = admin_title(@book, %i[title subtitle])
      render 'admin/books/show'
    end

    def new
      @book  = Zine.new
      @title = admin_title

      render 'admin/books/new'
    end

    def edit
      @title = admin_title(@book, %i[id title subtitle])
      render 'admin/books/edit'
    end

    def create
      @book = Zine.new(zine_params)

      if @book.save
        redirect_to [:admin, @book], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @book.update(zine_params)
        redirect_to [:admin, @book], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      redirect_to %i[admin zines], notice: t('.notice')
    end

    private

    def set_zine
      @book = Zine.find(params[:id])
    end

    def zine_params
      params.expect zine: %i[
        title subtitle content tweet summary locale
        description buy_url buy_info slug series published_at gallery_images_count
        price_in_cents height width depth weight pages words illustrations
        photographs printing ink definitions recipes has_index cover_style
        binding_style table_of_contents back_image_present canonical_id
        lite_download_present epub_download_present mobi_download_present
        print_black_and_white_a4_download_present print_color_a4_download_present
        print_color_download_present print_black_and_white_download_present
        screen_single_page_view_download_present screen_two_page_view_download_present
        publication_status featured_status featured_at position hide_from_index
      ]
    end
  end
end
