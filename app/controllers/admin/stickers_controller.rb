class Admin::StickersController < Admin::AdminController
  before_action :authorize
  before_action :set_poster,           only: [:show, :edit, :update, :destroy]
  before_action :set_publication_type, only: [:show, :edit, :new, :index]

  def index
    @posters = Poster.sticker.page(params[:page])
    @title = admin_title
    render "admin/posters/index"
  end

  def show
    return redirect_to([nil, "admin", "posters", @poster.id].join("/")) if @poster.poster?

    @title = admin_title(@poster, [:title, :subtitle])
    render "admin/posters/show"
  end

  def new
    @poster = Poster.new
    @title = admin_title
    render "admin/posters/new"
  end

  def edit
    return redirect_to([nil, "admin", "stickers", @poster.id, "edit"].join("/")) if @poster.poster?

    @title = admin_title(@poster, [:id, :title, :subtitle])
    render "admin/posters/edit"
  end

  def create
    @poster = Poster.new(poster_params)

    if @poster.save
      redirect_to [:admin, @poster], notice: "#{publication_type.to_s.capitalize.singularize} was successfully created."
    else
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
    @publication_type = "sticker"
  end

  def poster_params
    params.require(:poster).permit(:sticker, :title, :subtitle, :content,
      :content_format, :buy_info, :buy_url, :price_in_cents, :summary, :description, :front_image_present, :back_image_present, :read_download_present, :print_download_present, :lite_download_present, :slug, :height, :width)
  end
end
