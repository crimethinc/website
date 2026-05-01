class PodcastsController < ApplicationController
  def index
    @html_id  = 'page'
    @body_id  = 'podcast'
    @podcasts = Podcast.all.sort_by { |podcast| podcast.latest_episode.published_at }.reverse
    @editable = @podcasts.first
    @title    = PageTitle.new title_for :podcasts

    render "#{Current.theme}/podcasts/index"
  end

  def show
    @podcast = Podcast.find_by slug: params[:slug]
    return redirect_to(podcasts_path) if @podcast.blank?

    @html_id  = 'page'
    @body_id  = 'podcast'
    @episodes = @podcast.episodes.live.published
    @title    = PageTitle.new [title_for(:podcasts), @podcast.name]

    render "#{Current.theme}/podcasts/show"
  end

  def feed; end
end
