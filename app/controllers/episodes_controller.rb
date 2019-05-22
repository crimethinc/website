class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :transcript]

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

    render 'podcast/show'
  end

  private

  def set_episode
    @episode = Episode.find_by(id: params[:id])
    return @episode if @episode.present?

    redirect_to_podcast
  end

  def redirect_to_podcast
    podcast = Podcast.find_by(slug: params[:slug])

    redirect_path = podcast.blank? ? [:podcasts] : podcast.path
    redirect_to redirect_path
  end
end
