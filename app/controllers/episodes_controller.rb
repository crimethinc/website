class EpisodesController < ApplicationController
  before_action :set_podcast, only: %i[show transcript]
  before_action :set_episode, only: %i[show transcript]

  def show
    @html_id  = 'page'
    @body_id  = 'podcast'
    @editable = @episode
    @title    = PageTitle.new [title_for(:podcasts), @podcast.name, @episode.name]

    render "#{Current.theme}/episodes/show"
  end

  def transcript
    @html_id  = 'page'
    @body_id  = 'podcast'
    @editable = @episode
    @title    = PageTitle.new [title_for(:podcasts, :transcript), @podcast.name, @episode.name]

    render "#{Current.theme}/episodes/show"
  end

  private

  def set_podcast
    @podcast = Podcast.find_by(slug: params[:slug])
  end

  def set_episode
    if request.path.starts_with? '/draft'
      @episode = Episode.unscoped.find_by(draft_code: params[:draft_code])

      redirect_to(@episode.path) if @episode&.published?
    else
      @episode = Episode.live.find_by(podcast_id: @podcast, episode_number: params[:episode_number])
      return @episode if @episode.present?

      redirect_to_podcast
    end
  end

  def redirect_to_podcast
    redirect_path = @podcast.blank? ? [:podcasts] : @podcast.path
    redirect_to redirect_path
  end
end
