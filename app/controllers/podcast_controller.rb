class PodcastController < ApplicationController
  before_action :set_podcast,  only: [:index, :feed, :show]
  before_action :set_episodes, only: [:index, :feed]

  def index
    @html_id        = 'page'
    @body_id        = 'podcast'
    @podcasts       = Podcast.all.sort_by { |podcast| podcast.latest_episode.published_at }.reverse
    @editable       = @podcasts.first
    @title          = title_for :podcasts
  end

  def show
    @html_id = 'page'
    @body_id = 'podcast'
  end

  def feed; end

  private

  def set_podcast
    @podcast  = Podcast.find_by(title: 'The Ex-Worker')
  end

  def set_episodes
    @episodes = Episode.live.order(published_at: :desc).to_a
  end
end
