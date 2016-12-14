class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "secret", password: "superdupersecretsauce", except: :index

  protect_from_forgery with: :exception
  before_action :check_for_redirection
  before_action :set_social_links

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

  def setting(slug)
    Setting.find_by(slug: slug).try(:content)
  end
  helper_method :setting

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

  def set_social_links
    @social_links = Link.where(user: nil).all
  end

  def check_for_redirection
    redirect = Redirect.where(source_path: request.path).last
    if redirect.present?
      return redirect_to redirect.target_path, status: redirect.temporary? ? 302 : 301
    end
  end
end
