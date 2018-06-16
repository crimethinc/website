class VideosController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'watch'

    @videos  = Video.published.page(params[:page]).per(20)
  end

  def show
    @video = Video.where(slug: params[:slug])

    if @video.present?
      @video = @video.first
    else
      return redirect_to [:videos]
    end

    @html_id  = 'page'
    @body_id  = 'video'
    @title    = @video.title

    @editable = @video
  end
end
