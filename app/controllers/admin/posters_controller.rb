module Admin
  class PostersController < Admin::AdminController
    before_action :authorize
    before_action :set_poster, only: [:show, :edit, :update, :destroy]

    def index
      @posters = Poster.order(slug: :asc).page(params[:page]).per(50)
      @title = admin_title
    end

    def show
      @title = admin_title(@poster, [:title, :subtitle])
    end

    def new
      @poster = Poster.new
      @title  = admin_title
    end

    def edit
      @title = admin_title(@poster, [:id, :title, :subtitle])
    end

    def create
      @poster = Poster.new(poster_params)

      if @poster.save
        redirect_to [:admin, @poster], notice: 'Poster was successfully created.'
      else
        render :new
      end
    end

    def update
      if @poster.update(poster_params)
        redirect_to [:admin, @poster], notice: 'Poster was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @poster.destroy
      redirect_to [:admin, :posters], notice: 'Poster was successfully destroyed.'
    end

    private

    def set_poster
      @poster = Poster.find(params[:id])
    end

    def poster_params
      params.require(:poster).permit(:sticker, :title, :subtitle, :content,
                                     :buy_info, :buy_url, :price_in_cents, :summary, :description,
                                     :published_at, :front_image_present, :back_image_present,
                                     :front_download_present, :back_download_present, :slug, :height, :width,
                                     :depth, :front_image_format, :back_image_format, :front_color_image_present,
                                     :front_black_and_white_image_present, :back_color_image_present,
                                     :back_black_and_white_image_present, :front_color_download_present,
                                     :front_black_and_white_download_present, :back_color_download_present,
                                     :back_black_and_white_download_present, :publication_status)
    end
  end
end
