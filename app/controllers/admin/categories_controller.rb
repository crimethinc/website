class Admin::CategoriesController < Admin::AdminController
  before_action :authorize
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # /admin/categories
  def index
    @categories = Category.page(params[:page])
  end

  # /admin/categories/1
  def show
  end

  # /admin/categories/new
  def new
    @category = Category.new
  end

  # /admin/categories/1/edit
  def edit
  end

  # /admin/categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to [:admin, @category], notice: "Category was successfully created."
    else
      render :new
    end
  end

  # /admin/categories/1
  def update
    if @category.update(category_params)
      redirect_to [:admin, @category], notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  # /admin/categories/1
  def destroy
    @category.destroy
    redirect_to [:admin, :categories], notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug)
  end
end
