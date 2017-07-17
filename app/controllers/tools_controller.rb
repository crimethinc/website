class ToolsController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "products"
    @type    = "tools"
    @title   = "Tools"

    @posters  = Poster.poster.all
    @stickers = Poster.sticker.all
    @zines    = Book.zine.all
  end
end
