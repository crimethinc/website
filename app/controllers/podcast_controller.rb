class PodcastController < ApplicationController
  def index
    @html_id = "page"
    @body_id = "podcast"
    @podcast = Podcast.find_by(title: "The Ex-Worker")

    @episodes = @podcast.episodes.sort_by{|e| e.published_at }.reverse
    @latest_episode = @episodes.shift
  end

  def show
    @html_id = "page"
    @body_id = "podcast"
    @episode = Episode.find(params[:id])
  end

  def transcript
    @html_id = "page"
    @body_id = "podcast"
    @episode = Episode.find(params[:id])
    render "podcast/show"
  end

  def feed
    @podcast = Podcast.find_by(title: "The Ex-Worker")
    @episodes = @podcast.episodes.sort_by{|e| e.published_at }.reverse
  end
end
