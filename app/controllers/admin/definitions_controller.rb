module Admin
  class DefinitionsController < Admin::AdminController
    before_action :set_definition, only: %i[show edit update destroy]

    def index
      @definitions = Definition.page(params[:page]).per(10_000)
      @title = admin_title
    end

    def show
      @title = admin_title(@definition, %i[name])
    end

    def new
      @definition = Definition.new
      @title      = admin_title
    end

    def edit
      @title = admin_title(@definition, %i[id title subtitle])
    end

    def create
      @definition = Definition.new(definition_params)

      if @definition.save
        redirect_to [:admin, @definition], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @definition.update(definition_params)
        redirect_to [:admin, @definition], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @definition.destroy
      redirect_to %i[admin definitions], notice: t('.notice')
    end

    private

    def set_definition
      @definition = Definition.find(params[:id])
    end

    def definition_params
      params.expect definition: %i[
        title content publication_status locale
        published_at featured_status featured_at canonical_id
      ]
    end
  end
end
