class Admin::EpisodesController < Admin::AdminController
  before_action :authorize
  before_action :set_episode,      only: [:show, :edit, :update, :destroy]
  before_action :set_published_at, only: [:create, :update]
  before_action :set_podcasts,     only: [:new, :edit]

  def index
    redirect_to [:admin, :podcasts]
  end

  def show
    @title = admin_title(@episode, [:title, :subtitle])
  end

  def new
    @episode = Episode.new
    @title = admin_title
  end

  def edit
    @title = admin_title(@episode, [:id, :title, :subtitle])
  end

  def create
    @episode = Episode.new(episode_params)

    if @episode.save
      redirect_to [:admin, @episode], notice: "Episode was successfully created."
    else
      render :new
    end
  end

  def update
    if @episode.update(episode_params)
      redirect_to [:admin, @episode], notice: "Episode was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @episode.destroy
    redirect_to [:admin, :podcasts], notice: "Episode was successfully destroyed."
  end

  private

  def set_podcasts
    @podcasts = Podcast.all
  end

  def set_episode
    @episode = Episode.where(slug: params[:id])

    if @episode.blank?
      return redirect_to [:admin, :podcasts]
    else
      @episode = @episode.first
    end
  end

  def episode_params
    params.require(:episode).permit(:podcast_id, :title, :subtitle, :image, :content,
      :audio_mp3_url, :audio_mp3_file_size, :audio_ogg_url,
      :audio_ogg_file_size, :show_notes, :transcript, :audio_length,
      :duration, :audio_type, :tags, :published_at, :published_at_tz)
  end
end
