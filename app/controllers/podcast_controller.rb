class PodcastController < ApplicationController
  def index
    @podcast = Podcast.find_by(title: "The Ex-Worker")
  end

  def show
    @episode = Episode.find(params[:id])
  end

  def transcript
    @episode = Episode.find(params[:id])
  end

  def feed
    @podcast = Podcast.find_by(title: "The Ex-Worker")
  end
end
