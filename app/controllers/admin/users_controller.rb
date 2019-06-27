module Admin
  class UsersController < Admin::AdminController
    before_action :authorize_admin_role
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.page(params[:page])
      @title = admin_title
    end

    def show
      redirect_to %i[admin users]
    end

    def new
      @user  = User.new
      @title = admin_title
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to %i[admin users], notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def edit
      @title = admin_title(@user, %i[id username])
    end

    def update
      if @user.update(user_params)
        redirect_to %i[admin users], notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to %i[admin users], notice: 'User was successfully destroyed.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :role)
    end

    def authorize_admin_role
      return redirect_to [:admin] unless current_user.can_admin_users?
    end
  end
end
