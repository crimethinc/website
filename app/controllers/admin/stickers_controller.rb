module Admin
  class StickersController < Admin::AdminController
    before_action :authorize
    before_action :set_poster, only: [:show, :edit, :update, :destroy]

    def index
      @posters = Sticker.order(slug: :asc).page(params[:page])
      @title = admin_title
      render 'admin/posters/index'
    end

    def show
      @title = admin_title(@poster, [:title, :subtitle])
      render 'admin/posters/show'
    end

    def new
      @poster = Sticker.new
      @title  = admin_title
      render 'admin/posters/new'
    end

    def edit
      @title = admin_title(@poster, [:id, :title, :subtitle])
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
      redirect_to [:admin, :posters], notice: 'Sticker was successfully destroyed.'
    end

    private

    def set_poster
      @poster = Sticker.find(params[:id])
    end

    def poster_params
      params.require(:sticker).permit(:sticker, :title, :subtitle, :content, :published_at,
                                      :content_format, :buy_info, :buy_url, :price_in_cents,
                                      :summary, :description, :front_image_present,
                                      :back_image_present, :lite_download_present, :slug, :height,
                                      :width, :publication_status)
    end
  end
end
