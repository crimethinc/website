module Admin
  class LogosController < Admin::AdminController
    before_action :set_logo, only: %i[show edit update destroy]

    def index
      @logos         = Logo.order(slug: :asc).page(params[:page])
      @title         = admin_title
      @preview_width = 640
    end

    def show
      @title         = admin_title(@logo, %i[title subtitle])
      @preview_width = 640
    end

    def new
      @logo          = Logo.new
      @title         = admin_title
      @preview_width = 640
    end

    def edit
      @title         = admin_title(@logo, %i[id title subtitle])
      @preview_width = 640
    end

    def create
      @logo = Logo.new(logo_params)

      if @logo.save
        redirect_to [:admin, @logo], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @logo.update(logo_params)
        redirect_to [:admin, @logo], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @logo.destroy
      redirect_to %i[admin logos], notice: t('.notice')
    end

    private

    def set_logo
      @logo = Logo.find(params[:id])
    end

    def logo_params
      params.expect logo: %i[
        title subtitle description slug summary published_at locale publication_status
        position hide_from_index image_jpg image_png image_pdf image_svg image_tif
      ]
    end
  end
end
