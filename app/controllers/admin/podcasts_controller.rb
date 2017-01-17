class Admin::PodcastsController < Admin::AdminController
  before_action :authorize
  before_action :set_podcast, only: [:show, :edit, :update, :destroy]

  # /admin/podcasts
  def index
    @podcasts = Podcast.page(params[:page])
  end

  # /admin/podcasts/1
  def show
  end

  # /admin/podcasts/new
  def new
    @podcast = Podcast.new
  end

  # /admin/podcasts/1/edit
  def edit
  end

  # /admin/podcasts
  def create
    @podcast = Podcast.new(podcast_params)

    if @podcast.save
      redirect_to [:admin, @podcast], notice: "Podcast was successfully created."
    else
      render :new
    end
  end

  # /admin/podcasts/1
  def update
    if @podcast.update(podcast_params)
      redirect_to [:admin, @podcast], notice: "Podcast was successfully updated."
    else
      render :edit
    end
  end

  # /admin/podcasts/1
  def destroy
    @podcast.destroy
    redirect_to [:admin, :podcasts], notice: "Podcast was successfully destroyed."
  end

  private

  def set_podcast
    @podcast = Podcast.find(params[:id])
  end

  def podcast_params
    params.require(:podcast).permit(:title, :slug, :language, :copyright,
      :image, :content, :itunes_author, :itunes_categories, :itunes_owner_email,
      :itunes_explicit, :tags, :itunes_owner_name, :subtitle,
      :itunes_summary, :itunes_url)
  end
end
