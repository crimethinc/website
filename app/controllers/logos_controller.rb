class LogosController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @products = Logo.published.page(params[:page]).per(100)
    @title    = title_for prefix: :logos, keys: [:index]
  end

  def show
    @product = Logo.where(slug: params[:slug]).first
    return redirect_to [:logos] if @product.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'logos'
    @title   = title_for prefix: :zines, keys: [:index], suffix: @product.name
  end
end
