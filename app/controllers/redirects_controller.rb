class RedirectsController < ApplicationController
  def show
    if redirect.present?
      redirect_to redirect.target_path.downcase, status: redirect.temporary? ? :found : :moved_permanently
    else
      render file: Rails.root.join('public/404.html'), status: :not_found
    end
  end

  private

  def redirect
    return @redirect if @redirect.present?

    @redirect = Redirect.where(source_path: request.path.downcase).or(Redirect.where(source_path: "#{request.path.downcase}/")).last
  end
end
