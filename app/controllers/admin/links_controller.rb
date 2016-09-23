class Admin::LinksController < Admin::AdminController
  before_action :authorize
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # /admin/links
  def index
    @links = Link.all
  end

  # /admin/links/1
  def show
  end

  # /admin/links/new
  def new
    @link = Link.new
  end

  # /admin/links/new
  def create
    @link = Link.new(link_params)

    if @link.save
      redirect_to [:admin, :links], notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  # /admin/links/edit/1
  def edit
  end

  # /admin/links/edit/1
  def update
    if @link.update(link_params)
      redirect_to [:admin, :links], notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to [:admin, :links], notice: 'Link was successfully destroyed.'
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url)
  end
end
