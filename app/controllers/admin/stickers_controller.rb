module Admin
  class StickersController < Admin::AdminController
    before_action :authorize
    before_action :set_poster,           only: [:show, :edit, :update, :destroy]
    before_action :set_publication_type, only: [:show, :edit, :new, :index]
    before_action :set_statuses,         only: [:new, :edit]

    def index
      @posters = Poster.sticker.order(slug: :asc).page(params[:page])
      @title = admin_title
      render 'admin/posters/index'
    end

    def show
      return redirect_to([nil, 'admin', 'posters', @poster.id].join('/')) if @poster.poster?

      @title = admin_title(@poster, [:title, :subtitle])
      render 'admin/posters/show'
    end

    def new
      @poster = Poster.new
      @poster.status = Status.find_by(name: 'draft')
      @title = admin_title
      render 'admin/posters/new'
    end

    def edit
      return redirect_to([nil, 'admin', 'stickers', @poster.id, 'edit'].join('/')) if @poster.poster?

      @title = admin_title(@poster, [:id, :title, :subtitle])
      render 'admin/posters/edit'
    end

    def create
      @poster = Poster.new(poster_params)

      if @poster.save
        redirect_to [:admin, @poster], notice: "#{publication_type.to_s.capitalize.singularize} was successfully created."
      else
        set_statuses
        render :new
      end
    end

    def update
      if @poster.update(poster_params)
        redirect_to [:admin, @poster], notice: "#{publication_type.to_s.capitalize.singularize} was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      # Handled by admin/posters#destroy
    end

    private

    def set_poster
      @poster = Poster.find(params[:id])
    end

    def set_publication_type
      @publication_type = 'sticker'
    end

    def set_statuses
      @draft     = Status.find_by(name: 'draft')
      @published = Status.find_by(name: 'published')
    end

    def poster_params
      params.require(:poster).permit(:sticker, :title, :subtitle, :content, :published_at,
                                     :content_format, :buy_info, :buy_url, :price_in_cents,
                                     :summary, :description, :status_id, :front_image_present,
                                     :back_image_present, :lite_download_present, :slug, :height,
                                     :width, :publication_status)
    end
  end
end
