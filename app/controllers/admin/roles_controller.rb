class Admin::RolesController < Admin::AdminController
  before_action :authorize
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # /admin/roles
  def index
    @roles = Role.all
    @title = admin_title
  end

  # /admin/roles/1
  def show
    @title = admin_title(@role, [:name])
  end

  # /admin/roles/new
  def new
    @role = Role.new
    @title = admin_title
  end

  # /admin/roles/1/edit
  def edit
    @title = admin_title(@role, [:id, :name])
  end

  # /admin/roles
  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to [:admin, @role], notice: "Role was successfully created."
    else
      render :new
    end
  end

  # /admin/roles/1
  def update
    if @role.update(role_params)
      redirect_to [:admin, @role], notice: "Role was successfully updated."
    else
      render :edit
    end
  end

  # /admin/roles/1
  def destroy
    @role.destroy
    redirect_to [:admin, :roles], notice: "Role was successfully destroyed."
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
