class Admin::EpisodesController < Admin::AdminController
  before_action :authorize
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  # /admin/episodes
  def index
    redirect_to [:admin, :podcasts]
  end

  # /admin/episodes/1
  def show
    @title = admin_title(@episode, [:title, :subtitle])
  end

  # /admin/episodes/new
  def new
    @episode = Episode.new
    @title = admin_title
  end

  # /admin/episodes/1/edit
  def edit
    @title = admin_title(@episode, [:id, :title, :subtitle])
  end

  # /admin/episodes
  def create
    @episode = Episode.new(episode_params)

    if @episode.save
      redirect_to [:admin, @episode], notice: "Episode was successfully created."
    else
      render :new
    end
  end

  # /admin/episodes/1
  def update
    if @episode.update(episode_params)
      redirect_to [:admin, @episode], notice: "Episode was successfully updated."
    else
      render :edit
    end
  end

  # /admin/episodes/1
  def destroy
    @episode.destroy
    redirect_to [:admin, :podcasts], notice: "Episode was successfully destroyed."
  end

  private

  def set_episode
    @episode = Episode.find_by(slug: params[:id])
  end

  def episode_params
    params.require(:episode).permit(:podcast_id, :title, :subtitle, :image, :content,
      :audio_mp3_url, :audio_mp3_file_size, :audio_ogg_url,
      :audio_ogg_file_size, :show_notes, :transcript, :audio_length,
      :duration, :audio_type, :tags, :published_at)
  end
end
