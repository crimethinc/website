class Admin::RedirectsController < Admin::AdminController
  before_action :authorize
  before_action :set_redirect, only: [:show, :edit, :update, :destroy]

  # /admin/redirects
  def index
    @redirects = Redirect.order(:source_path).page(params[:page])
  end

  # /admin/redirects/1
  def show
  end

  # /admin/redirects/new
  def new
    @redirect = Redirect.new
  end

  # /admin/redirects/1/edit
  def edit
  end

  # /admin/redirects
  def create
    @redirect = Redirect.new(redirect_params)

    if @redirect.save
      redirect_to [:admin, @redirect], notice: 'Redirect was successfully created.'
    else
      render :new
    end
  end

  # /admin/redirects/1
  def update
    if @redirect.update(redirect_params)
      redirect_to [:admin, @redirect], notice: 'Redirect was successfully updated.'
    else
      render :edit
    end
  end

  # /admin/redirects/1
  def destroy
    @redirect.destroy
    redirect_to [:admin, :redirects], notice: 'Redirect was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redirect
      @redirect = Redirect.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def redirect_params
      params.require(:redirect).permit(:source_path, :target_path, :temporary)
    end
end
