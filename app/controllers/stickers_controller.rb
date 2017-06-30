class StickersController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "tools"
    @type    = "sticker"
  end

  def show
    @html_id = "page"
    @body_id = "tools"
    @type    = "stickers"
  end
end
