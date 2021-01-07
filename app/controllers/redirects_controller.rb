class RedirectsController < ApplicationController
  def show
    redirect = Redirect.where(source_path: request.path.downcase).last
    redirect = Redirect.where(source_path: "#{request.path.downcase}/").last if redirect.blank?

    if redirect.present?
      redirect_to(redirect.target_path.downcase, status: redirect.temporary? ? :found : :moved_permanently)
    else
      render file: Rails.root.join('public/404.html'), status: :not_found
    end
  end
end
