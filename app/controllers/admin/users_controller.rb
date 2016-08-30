class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # /admin/users
  def index
    @users = User.all
  end

  # /admin/users/1
  def show
  end

  # /admin/users/new
  def new
    @user = User.new
  end

  # /admin/users/new
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to [:admin, :users], notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # /admin/users/edit/1
  def edit
  end

  # /admin/users/edit/1
  def update
    if @user.update(user_params)
      redirect_to [:admin, :users], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to [:admin, :users], notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :name)
  end
end
