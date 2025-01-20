class UsersController < Admin::AdminController
  before_action :authorize

  layout 'admin'

  # /settings
  def edit; end

  # /settings
  def update
    if Current.user.update(user_params)
      redirect_to [:admin], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.expect user: %i[username password password_confirmation]
  end
end
