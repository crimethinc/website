module Auth
  class UsersController < Admin::AdminController
    before_action :authorize
    before_action :set_user

    layout 'admin'

    # /settings
    def edit; end

    # /settings
    def update
      if @user.update(user_params)
        redirect_to [:admin], notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
