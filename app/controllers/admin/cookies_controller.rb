module Admin
  class CookiesController < ApplicationController
    def create
      cookies[:theme] = cookie_params[:theme]

      redirect_back fallback_location: root_path
    end

    private

    def cookie_params = params.expect cookie: [:theme]
  end
end
