class PodcastController < ApplicationController
  def index
    @slug = "podcast"
    @podcast = Podcast.find_by(title: "The Ex-Worker")

    @episodes = @podcast.episodes.sort_by{|e| e.published_at }.reverse
    @latest_episode = @episodes.shift
  end

  def show
    @slug = "podcast"
    @episode = Episode.find(params[:id])
  end

  def transcript
    @slug = "podcast"
    @episode = Episode.find(params[:id])
  end

  def feed
    @podcast = Podcast.find_by(title: "The Ex-Worker")
  end
end
