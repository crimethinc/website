module Auth
  class UsersController < Admin::AdminController
    before_action :authorize, only: [:show, :edit, :update]
    before_action :set_user,  only: [:show, :edit, :update]
    layout 'admin'

    # /signup
    def new
      if signed_in?
        redirect_to(admin_url)
      elsif User.count.zero?
        @user = User.new
      else
        redirect_to(signin_path)
      end
    end

    # /signup
    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to signin_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def show; end

    # /settings
    def edit; end

    # /profile
    def update
      if @user.update(user_params)
        redirect_to profile_path, notice: 'User was successfully updated.'
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
