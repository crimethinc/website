class Admin::PagesController < Admin::AdminController
  before_action :authorize
  before_action :set_page,      only: [:show, :edit, :update, :destroy]
  after_action  :organize_page, only: [:create, :update]

  # /admin/pages
  def index
    @pages = Page.page(params[:page])
    @title = admin_title
  end

  # /admin/pages/1
  def show
    @title = admin_title(@page, [:title])
  end

  # /admin/pages/new
  def new
    @page = Page.new
    @title = admin_title
  end

  # /admin/pages/1/edit
  def edit
    @title = admin_title(@page, [:id, :title, :subtitle])
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
    if params[:draft_code].present?
      @page = Page.find_by(draft_code: params[:draft_code])
    else
      @page = Page.find(params[:id])
    end
  end

  def organize_page
    tag_assigner = TagAssigner.parse_glob(params[:tags])
    unless tag_assigner.blank?
      tag_assigner.assign_tags_to!(@page)
    end
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :content,
                                 :year, :month, :day,
                                 :slug, :tags, :draft_code, :status_id,
                                 :published_at, :tags, :categories,
                                 :image, :image_description, :css,
                                 :hide_header, :hide_footer, :hide_layout)
  end
end
