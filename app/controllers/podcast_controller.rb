class PodcastController < ApplicationController
  before_action :set_podcast,  only: [:index, :feed]
  before_action :set_episodes, only: [:index, :feed]

  def index
    @html_id        = "page"
    @body_id        = "podcast"
    @latest_episode = @episodes.shift
    @editable       = @latest_episode.podcast
    @title          = @podcast.name
  end

  def show
    @html_id = "page"
    @body_id = "podcast"
    @episode = Episode.find_by(slug: params[:slug])
    @editable = @episode
    @title = @episode.name
  end

  def transcript
    @html_id = "page"
    @body_id = "podcast"
    @episode = Episode.find_by(slug: params[:slug])

    render "podcast/show"
  end

  def feed
  end

  private

  def set_podcast
    @podcast  = Podcast.find_by(title: "The Ex-Worker")
  end

  def set_episodes
    @episodes = Episode.live.order(published_at: :desc).to_a
  end
end
