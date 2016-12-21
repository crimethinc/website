class Admin::EpisodesController < Admin::AdminController
  before_action :authorize
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  # /admin/episodes
  def index
    @episodes = Episode.all
  end

  # /admin/episodes/1
  def show
  end

  # /admin/episodes/new
  def new
    @episode = Episode.new
  end

  # /admin/episodes/1/edit
  def edit
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
    redirect_to [:admin, :episodes], notice: "Episode was successfully destroyed."
  end

  private

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:title, :subtitle, :image, :content, :audio_url, :audio_length, :audio_type, :tags)
  end
end
