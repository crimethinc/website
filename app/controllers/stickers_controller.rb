class StickersController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'tools'
    @type     = 'stickers'
    @title    = 'Stickers'

    stickers = Sticker.order(published_at: :desc).live.published

    @featured_tools = stickers.where.not(buy_url: nil)
    @tools          = stickers.where(buy_url: nil)

    render 'tools/index'
  end

  def show
    @tool = Sticker.published.live.where(slug: params[:slug])
    return redirect_to [:stickers] if @tool.blank?

    @tool = @tool.first
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'stickers'

    @title = "Stickers : #{@tool.name}"
    @editable = @tool

    render 'tools/show'
  end
end
