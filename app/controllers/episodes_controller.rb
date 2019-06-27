class EpisodesController < ApplicationController
  before_action :set_podcast, only: %i[show transcript]
  before_action :set_episode, only: %i[show transcript]

  def show
    @html_id  = 'page'
    @body_id  = 'podcast'
    @editable = @episode
    @title    = title_for :podcasts, @episode.name, :transcript
  end

  def transcript
    @html_id  = 'page'
    @body_id  = 'podcast'
    @editable = @episode
    @title    = title_for :podcasts, @episode.name, :transcript

    render 'episodes/show'
  end

  private

  def set_podcast
    @podcast = Podcast.find_by(slug: params[:slug])
  end

  def set_episode
    @episode = Episode.find_by(podcast_id: @podcast, episode_number: params[:episode_number])
    return @episode if @episode.present?

    redirect_to_podcast
  end

  def redirect_to_podcast
    redirect_path = @podcast.blank? ? [:podcasts] : @podcast.path
    redirect_to redirect_path
  end
end
