class LogosController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'logos'
    @title    = 'logos'
    @products = Logo.published.page(params[:page]).per(100)
  end

  def show
    @product = Logo.where(slug: params[:slug])
    return redirect_to [:logos] if @product.blank?

    @html_id = 'page'
    @body_id = 'products'
    @type    = 'logos'

    @product = @product.first
    @title   = "logos : #{@product.name}"
  end
end
