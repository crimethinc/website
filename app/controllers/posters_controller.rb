class PostersController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'posters'
    @title   = title_for :posters

    posters = Poster.order(published_at: :desc).live.published

    @featured_tools = posters.where.not(buy_url: nil)
    @tools          = posters.where(buy_url: nil)

    render 'tools/index'
  end

  def show
    @tool = Poster.live.published.where(slug: params[:slug]).first
    return redirect_to [:posters] if @tool.blank?

    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'posters'

    @title    = title_for :posters, @tool.name
    @editable = @tool

    render 'tools/show'
  end
end
