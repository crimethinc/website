class Admin::ThemesController < Admin::AdminController
  before_action :authorize
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  # /admin/themes
  def index
    @themes = Theme.page(params[:page])
  end

  # /admin/themes/1
  def show
  end

  # /admin/themes/new
  def new
    @theme = Theme.new
  end

  # /admin/themes/1/edit
  def edit
  end

  # /admin/themes
  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      redirect_to [:admin, :themes], notice: "Theme was successfully created."
    else
      render :new
    end
  end

  # /admin/themes/1
  def update
    if @theme.update(theme_params)
      redirect_to [:admin, :themes], notice: "Theme was successfully updated."
    else
      render :edit
    end
  end

  # /admin/themes/1
  def destroy
    @theme.destroy
    redirect_to [:admin, :themes], notice: "Theme was successfully destroyed."
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:name, :slug, :description)
  end
end
