class LogosController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "logos"
    @title    = "logos"
    @products = Logo.page(params[:page]).per(100)
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "logos"
    @product = Logo.find_by(slug: params[:slug])
    @title   = "logos : #{@product.name}"
  end
end
