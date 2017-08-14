class Admin::SettingsController < Admin::AdminController
  before_action :authorize
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  def index
    @body_id = "settings"
    @settings = Setting.order(name: :asc).page(params[:page])
    @title = admin_title
  end

  def show
    redirect_to [:admin, :settings]
  end

  def new
    redirect_to [:admin, :settings]
  end

  def edit
    @title = admin_title(@setting, [:id, :name])
  end

  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to [:admin, @setting], notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  def update
    if @setting.update(setting_params)
      redirect_to [:admin, @setting], notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

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
