module Admin
  class StickersController < Admin::AdminController
    before_action :set_poster, only: %i[show edit update destroy]

    def index
      @posters = Sticker.order(slug: :asc).page(params[:page])
      @title = admin_title
      @preview_width = 640
      render 'admin/posters/index'
    end

    def show
      @title = admin_title(@poster, %i[title subtitle])
      @preview_width = 640
      render 'admin/posters/show'
    end

    def new
      @poster = Sticker.new
      @title  = admin_title
      @preview_width = 640
      render 'admin/posters/new'
    end

    def edit
      @title = admin_title(@poster, %i[id title subtitle])
      @preview_width = 640
      render 'admin/posters/edit'
    end

    def create
      @poster = Sticker.new(poster_params)

      if @poster.save
        redirect_to [:admin, @poster], notice: 'Sticker was successfully created.'
      else
        render :new
      end
    end

    def update
      if @poster.update(poster_params)
        redirect_to [:admin, @poster], notice: 'Sticker was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @poster.destroy
      redirect_to %i[admin posters], notice: 'Sticker was successfully destroyed.'
    end

    private

    def set_poster
      @poster = Sticker.find(params[:id])
    end

    def poster_params
      params.require(:sticker).permit(
        :title, :subtitle, :content, :buy_info, :buy_url, :locale,
        :price_in_cents, :summary, :description, :slug, :height, :width, :depth,
        :front_image_format, :back_image_format, :published_at, :front_color_image_present,
        :front_black_and_white_image_present, :back_color_image_present,
        :back_black_and_white_image_present, :front_color_download_present,
        :front_black_and_white_download_present, :back_color_download_present,
        :back_black_and_white_download_present, :publication_status,
        :featured_status, :featured_at, :canonical_id, :position, :hide_from_index,
        :image_front_color_image,
        :image_front_black_and_white_image,
        :image_back_color_image,
        :image_back_black_and_white_image,
        :image_front_color_download,
        :image_front_black_and_white_download,
        :image_back_color_download,
        :image_back_black_and_white_download
      )
    end
  end
end
