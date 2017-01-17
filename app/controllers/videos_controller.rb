class VideosController < ApplicationController
  def show
    @video = Video.find_by(slug: params[:slug])

    @html_id  = "page"
    @body_id  = "video"
    @title    = @video.title
  end
end
