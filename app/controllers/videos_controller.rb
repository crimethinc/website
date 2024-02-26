class VideosController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'watch'
    @title   = PageTitle.new title_for :videos
    @videos  = Video.live.published.page(params[:page]).per(20)

    render "#{Current.theme}/videos/index"
  end

  def show
    @video = Video.live.published.where(slug: params[:slug]).first
    return redirect_to [:videos] if @video.blank?

    @editable = @video
    @html_id  = 'page'
    @body_id  = 'video'
    @title    = PageTitle.new [title_for(:videos), @video.title].compact

    render "#{Current.theme}/videos/show"
  end
end
