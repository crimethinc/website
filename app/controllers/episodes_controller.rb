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
    @episode = Episode.where(slug: params[:slug])
    return redirect_to [:podcast] if @episode.blank?

    @episode = @episode.first
  end
end
