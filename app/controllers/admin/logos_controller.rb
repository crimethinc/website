module Admin
  class LogosController < Admin::AdminController
    before_action :set_logo, only: [:show, :edit, :update, :destroy]

    def index
      @logos = Logo.order(slug: :asc).page(params[:page])
      @title = admin_title
    end

    def show
      @title = admin_title(@logo, [:title, :subtitle])
    end

    def new
      @logo  = Logo.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@logo, [:id, :title, :subtitle])
    end

    def create
      @logo = Logo.new(logo_params)

      if @logo.save
        redirect_to [:admin, @logo], notice: 'Logo was successfully created.'
      else
        render :new
      end
    end

    def update
      if @logo.update(logo_params)
        redirect_to [:admin, @logo], notice: 'Logo was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @logo.destroy
      redirect_to [:admin, :logos], notice: 'Logo was successfully destroyed.'
    end

    private

    def set_logo
      @logo = Logo.find(params[:id])
    end

    def logo_params
      params.require(:logo).permit(:title, :subtitle, :description, :slug, :height,
                                   :width, :summary, :published_at,
                                   :jpg_url_present, :png_url_present, :pdf_url_present,
                                   :svg_url_present, :tif_url_present, :publication_status)
    end
  end
end
