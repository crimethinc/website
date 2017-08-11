class Admin::LinksController < Admin::AdminController
  before_action :authorize
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.page(params[:page])
    @title = admin_title
  end

  def show
    redirect_to [:admin, :links]
  end

  def new
    @link = Link.new
    @title = admin_title
  end

  def create
    @link = Link.new(link_params)

    if @link.save
      redirect_to [:admin, :links], notice: "Link was successfully created."
    else
      render :new
    end
  end

  def edit
    @title = admin_title(@link, [:id, :name])
  end

  def update
    if @link.update(link_params)
      redirect_to [:admin, :links], notice: "Link was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to [:admin, :links], notice: "Link was successfully destroyed."
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url, :user_id)
  end
end
