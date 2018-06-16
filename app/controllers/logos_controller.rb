class LogosController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'products'
    @type     = 'logos'
    @title    = 'logos'
    @products = Logo.published.page(params[:page]).per(100)
  end

  def show
    @html_id = 'page'
    @body_id = 'products'
    @type    = 'logos'
    @product = Logo.where(slug: params[:slug])

    if @product.blank?
      return redirect_to [:logos]
    else
      @product = @product.first
    end

    @title   = "logos : #{@product.name}"
  end
end
