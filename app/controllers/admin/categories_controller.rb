module Admin
  class CategoriesController < Admin::AdminController
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.page(params[:page])
      @title = admin_title
    end

    def show
      redirect_to [:admin, :categories]
    end

    def new
      @category = Category.new
      @title    = admin_title
    end

    def edit
      @title = admin_title(@category, [:id, :name])
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to [:admin, @category], notice: 'Category was successfully created.'
      else
        render :new
      end
    end

    def update
      if @category.update(category_params)
        redirect_to [:admin, @category], notice: 'Category was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @category.destroy
      redirect_to [:admin, :categories], notice: 'Category was successfully destroyed.'
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :slug)
    end
  end
end
