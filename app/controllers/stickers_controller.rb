class StickersController < ApplicationController
  def index
    @html_id  = "page"
    @body_id  = "products"
    @type     = "sticker"
    @products = Poster.sticker.all

    render "products/index"
  end

  def show
    @html_id = "page"
    @body_id = "tools"
    @type    = "stickers"
  end
end
