class Admin::PagesController < Admin::AdminController
  before_action :authorize
  before_action :set_page,      only: [:show, :edit, :update, :destroy]
  after_action  :organize_page, only: [:create, :update]

  # /admin/pages
  def index
    @pages = Page.all
  end

  # /admin/pages/1
  def show
  end

  # /admin/pages/new
  def new
    @page = Page.new
  end

  # /admin/pages/1/edit
  def edit
  end

  # /admin/pages
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to [:admin, @page], notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  # /admin/pages/1
  def update
    if @page.update(page_params)
      redirect_to [:admin, @page], notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  # /admin/pages/1
  def destroy
    @page.destroy
    redirect_to [:admin, :pages], notice: 'Page was successfully destroyed.'
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def organize_page
    # TODO
    # @page.save_tags!(params[:tags])
    # @page.save_categories!(params[:categories])
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :content,
                                 :year, :month, :day,
                                 :slug, :draft_code, :status,
                                 :published_at, :tags, :categories,
                                 :image, :image_description, :css,
                                 :hide_header, :hide_footer, :hide_layout)
  end
end
