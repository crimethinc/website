module Admin
  class RedirectsController < Admin::AdminController
    before_action :authorize
    before_action :set_redirect, only: [:show, :edit, :update, :destroy]

    def index
      if params[:from].present?
        from = params[:from].strip.sub(%r{https*://}, '').sub(/cwc.im|crimethinc.com/, '')

        @redirects = Redirect.order(:source_path).where(source_path: from).page(params[:page])

        @redirects = Redirect.order(:source_path).where(source_path: "/#{from}").page(params[:page]) if @redirects.blank?
      elsif params[:to].present?
        to = params[:to].strip.sub(%r{https*://}, '').sub(/cwc.im|crimethinc.com/, '')

        @redirects = Redirect.order(:source_path).where(target_path: to).page(params[:page])

        @redirects = Redirect.order(:source_path).where(target_path: "/#{to}").page(params[:page]) if @redirects.blank?
      else
        @redirects = Redirect.order(:source_path).page(params[:page])
      end

      @title = admin_title
    end

    def show
      @title = admin_title(@redirect, [:source_path])
    end

    def new
      @redirect = Redirect.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@redirect, [:id, :source_path])
    end

    def create
      @redirect = Redirect.new(redirect_params)

      if @redirect.save
        redirect_to [:admin, @redirect], notice: 'Redirect was successfully created.'
      else
        render :new
      end
    end

    def update
      if @redirect.update(redirect_params)
        redirect_to [:admin, @redirect], notice: 'Redirect was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @redirect.destroy
      redirect_to [:admin, :redirects], notice: 'Redirect was successfully destroyed.'
    end

    private

    def set_redirect
      @redirect = Redirect.find(params[:id])
    end

    def redirect_params
      params.require(:redirect).permit(:source_path, :target_path, :temporary)
    end
  end
end
