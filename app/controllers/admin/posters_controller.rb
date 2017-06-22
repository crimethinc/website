class Admin::PostersController < Admin::AdminController
  before_action :authorize
  before_action :set_poster,           only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]

  def index
    @posters = Poster.poster.page(params[:page])
    @title = admin_title
  end

  def show
    return redirect_to([nil, "admin", "stickers", @poster.id].join("/")) if @poster.sticker?

    @title = admin_title(@poster, [:title, :subtitle])
  end

  def new
    @poster = Poster.new
    @title = admin_title
  end

  def edit
    return redirect_to([nil, "admin", "stickers", @poster.id, "edit"].join("/")) if @poster.sticker?

    @title = admin_title(@poster, [:id, :title, :subtitle])
  end

  def create
    @poster = Poster.new(poster_params)
    publication_type = @poster.sticker? ? :stickers :  :posters

    if @poster.save
      redirect_to [:admin, @poster], notice: "#{publication_type.to_s.capitalize.singularize} was successfully created."
    else
      render :new
    end
  end

  def update
    publication_type = @poster.sticker? ? :stickers :  :posters
    if @poster.update(poster_params)
      redirect_to [:admin, @poster], notice: "#{publication_type.to_s.capitalize.singularize} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    publication_type = @poster.sticker? ? :stickers :  :posters
    @poster.destroy
    redirect_to [:admin, publication_type], notice: "#{publication_type.to_s.capitalize.singularize} was successfully destroyed."
  end

  private

  def set_poster
    @poster = Poster.find(params[:id])
  end

  def set_publication_type
    @publication_type = "poster"
  end

  def poster_params
    params.require(:poster).permit(:sticker, :title, :subtitle, :content, :content_format,
      :buy_info, :buy_url, :price_in_cents, :summary, :description,
      :front_image_present, :back_image_present, :front_download_present, :back_download_present,
      :slug, :height, :width, :depth, :front_image_format, :back_image_format)
  end
end
