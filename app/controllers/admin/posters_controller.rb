module Admin
  class PostersController < Admin::AdminController
    before_action :set_poster, only: %i[show edit update destroy]

    def index
      @posters = Poster.order(slug: :asc).page(params[:page]).per(50)
      @title = admin_title
      @preview_width = 640
    end

    def show
      @title = admin_title(@poster, %i[title subtitle])
      @preview_width = 640
    end

    def new
      @poster = Poster.new
      @title  = admin_title
      @preview_width = 640
    end

    def edit
      @title = admin_title(@poster, %i[id title subtitle])
      @preview_width = 640
    end

    def create
      @poster = Poster.new(poster_params)

      if @poster.save
        redirect_to [:admin, @poster], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @poster.update(poster_params)
        redirect_to [:admin, @poster], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @poster.destroy
      redirect_to %i[admin posters], notice: t('.notice')
    end

    private

    def set_poster
      @poster = Poster.find(params[:id])
    end

    def poster_params
      params.expect poster: %i[
        sticker title subtitle content locale
        buy_info buy_url price_in_cents summary description
        published_at front_image_present back_image_present
        front_download_present back_download_present slug height width
        depth front_image_format back_image_format front_color_image_present
        front_black_and_white_image_present back_color_image_present
        back_black_and_white_image_present front_color_download_present
        front_black_and_white_download_present back_color_download_present
        back_black_and_white_download_present publication_status
        featured_status featured_at canonical_id position hide_from_index
        image_front_color_image
        image_front_black_and_white_image
        image_back_color_image
        image_back_black_and_white_image
        image_front_color_download
        image_front_black_and_white_download
        image_back_color_download
        image_back_black_and_white_download
      ]
    end
  end
end
