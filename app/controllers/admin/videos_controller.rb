class Admin::VideosController < Admin::AdminController
  before_action :authorize
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # /admin/videos
  def index
    @videos = Video.page(params[:page])
  end

  # /admin/videos/1
  def show
  end

  # /admin/videos/new
  def new
    @video = Video.new
  end

  # /admin/videos/1/edit
  def edit
  end

  # /admin/videos
  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to [:admin, @video], notice: "Video was successfully created."
    else
      render :new
    end
  end

  # /admin/videos/1
  def update
    if @video.update(video_params)
      redirect_to [:admin, @video], notice: "Video was successfully updated."
    else
      render :edit
    end
  end

  # /admin/videos/1
  def destroy
    @video.destroy
    redirect_to [:admin, :videos], notice: "Video was successfully destroyed."
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :subtitle, :content, :slug, :vimeo_id, :image, :image_description, :published_at, :tweet, :summary, :quality, :duration)
  end
end
