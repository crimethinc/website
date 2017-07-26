class LogosController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "logos"
    @products = Logo.order("published_at desc").page(params[:page]).per(10)
    @title    = "logos"
  end

  def show
    @html_id = "page"
    @body_id = "products"
    @type    = "logos"
    @product = Logo.find_by(slug: params[:slug])
    @title   = "logos : #{@product.name}"
  end
end
