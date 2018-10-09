class VideosController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'watch'
    @title   = title_for prefix: :videos, keys: [:index]
    @videos  = Video.published.page(params[:page]).per(20)
  end

  def show
    @video = Video.where(slug: params[:slug])
    return redirect_to [:videos] if @video.blank?

    @video    = @video.first
    @editable = @video

    @html_id  = 'page'
    @body_id  = 'video'
    @title    = title_for prefix: :videos, keys: [:index], suffix: @video.title
  end
end
