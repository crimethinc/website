class PodcastController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'podcast'
    @podcasts = Podcast.all.sort_by { |podcast| podcast.latest_episode.published_at }.reverse
    @editable = @podcasts.first
    @title    = PageTitle.new title_for :podcasts
  end

  def show
    @html_id = 'page'
    @body_id = 'podcast'
    @podcast = Podcast.find_by(slug: params[:slug])
    @title   = PageTitle.new title_for @podcast.name
  end

  def feed; end
end
