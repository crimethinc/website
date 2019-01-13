module Admin
  class VideosController < Admin::AdminController
    before_action :set_video,        only: [:show, :edit, :update, :destroy]
    before_action :set_published_at, only: [:create, :update]

    # /admin/videos
    def index
      @videos = Video.order(slug: :asc).page(params[:page])
      @title  = admin_title
    end

    # /admin/videos/1
    def show
      @title = admin_title(@video, [:title])
    end

    # /admin/videos/new
    def new
      @video = Video.new
      @title = admin_title
    end

    # /admin/videos/1/edit
    def edit
      @title = admin_title(@video, [:id, :title, :subtitle])
    end

    # /admin/videos
    def create
      @video = Video.new(video_params)

      if @video.save
        redirect_to [:admin, @video], notice: 'Video was successfully created.'
      else
        render :new
      end
    end

    # /admin/videos/1
    def update
      if @video.update(video_params)
        redirect_to [:admin, @video], notice: 'Video was successfully updated.'
      else
        render :edit
      end
    end

    # /admin/videos/1
    def destroy
      @video.destroy
      redirect_to [:admin, :videos], notice: 'Video was successfully destroyed.'
    end

    private

    def set_video
      @video = Video.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:title, :subtitle, :content, :slug, :vimeo_id, :image,
                                    :image_description, :published_at, :tweet, :summary,
                                    :quality, :duration, :published_at_tz, :publication_status)
    end
  end
end
