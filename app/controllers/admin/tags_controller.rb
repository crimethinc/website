module Admin
  class TagsController < Admin::AdminController
    before_action :set_tag, only: %i[show edit update destroy]

    def index
      @tags  = Tag.order(name: :asc).page(params[:page])
      @title = admin_title
    end

    def show
      @title = admin_title(@tag, %i[id name])
    end

    def new
      @tag   = Tag.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@tag, %i[id name])
    end

    def create
      @tag = Tag.new(tag_params)

      if @tag.save
        redirect_to [:admin, @tag], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @tag.update(tag_params)
        redirect_to [:admin, @tag], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @tag.destroy
      redirect_to %i[admin tags], notice: t('.notice')
    end

    private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.expect tag: %i[name slug description]
    end
  end
end
