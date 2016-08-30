class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def signed_in?
    current_user
  end
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to signin_url, alert: "You need to sign in to view that page." unless signed_in?
  end

  def listing?
    action_name == "index"
  end
  helper_method :listing?

  def showing?
    action_name == "show"
  end
  helper_method :showing?

  def editing?
    action_name == "edit"
  end
  helper_method :editing?

  def creating?
    action_name == "new"
  end
  helper_method :creating?
end
