class VideosController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "watch"

    @videos  = Video.all.page(params[:page]).per(10)
  end

  def show
    @video = Video.find_by!(slug: params[:slug])

    @html_id  = "page"
    @body_id  = "video"
    @title    = @video.title
  end
end
