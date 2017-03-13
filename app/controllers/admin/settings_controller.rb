class Admin::SettingsController < Admin::AdminController
  before_action :authorize
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # /admin/settings
  def index
    @body_id = "settings"
    @settings = Setting.order("name ASC").page(params[:page])
    @title = admin_title
  end

  # /admin/settings/1
  def show
    @title = admin_title(@setting, [:name])
  end

  # /admin/settings/new
  def new
    redirect_to [:admin, :settings]
    @title = admin_title
  end

  # /admin/settings/1/edit
  def edit
    @title = admin_title(@setting, [:id, :name])
  end

  # /admin/settings
  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to [:admin, @setting], notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  # /admin/settings/1
  def update
    if @setting.update(setting_params)
      redirect_to [:admin, @setting], notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  # /admin/settings/1
  def destroy
    @setting.destroy
    redirect_to [:admin, :settings], notice: 'Setting was successfully destroyed.'
  end

  private

  def set_setting
    @setting = Setting.find(params[:id])
  end

  def setting_params
    params.require(:setting).permit(:name, :saved_content)
  end
end
