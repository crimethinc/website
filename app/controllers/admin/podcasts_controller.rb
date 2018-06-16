class Admin::PodcastsController < Admin::AdminController
  before_action :authorize
  before_action :set_podcast, only: [:show, :edit, :update, :destroy]

  def index
    @podcasts = Podcast.all
    @title = admin_title
  end

  def show
    @title = admin_title(@podcast, [:id, :title])
  end

  def new
    @podcast = Podcast.new
    @title = admin_title
  end

  def edit
    @title = admin_title(@podcast, [:id, :title, :subtitle])
  end

  def create
    @podcast = Podcast.new(podcast_params)

    if @podcast.save
      redirect_to [:admin, @podcast], notice: 'Podcast was successfully created.'
    else
      render :new
    end
  end

  def update
    if @podcast.update(podcast_params)
      redirect_to [:admin, @podcast], notice: 'Podcast was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @podcast.destroy
    redirect_to [:admin, :podcasts], notice: 'Podcast was successfully destroyed.'
  end

  private

  def set_podcast
    @podcast = Podcast.find(params[:id])
  end

  def podcast_params
    params.require(:podcast).permit(:title, :slug, :language, :copyright,
      :image, :content, :itunes_author, :itunes_categories, :itunes_owner_email,
      :itunes_explicit, :tags, :itunes_owner_name, :subtitle,
      :itunes_summary, :itunes_url, :episode_prefix)
  end
end
