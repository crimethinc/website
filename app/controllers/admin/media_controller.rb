module Admin
  class MediaController < Admin::AdminController
    before_action :set_medium, only: %i[show edit update destroy]

    def index
      @media = Medium.all
    end

    def show; end

    def new
      @medium = Medium.new
    end

    def edit; end

    def create
      @medium = Medium.new(medium_params)

      if @medium.save
        redirect_to @medium, notice: 'Medium was successfully created.'
      else
        render :new
      end
    end

    def update
      if @medium.update(medium_params)
        redirect_to @medium, notice: 'Medium was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @medium.destroy
      redirect_to media_url, notice: 'Medium was successfully destroyed.'
    end

    private

    def set_medium
      @medium = Medium.find(params[:id])
    end

    def medium_params
      params.require(:medium).permit(:title, :subtitle, :content, :slug)
    end
  end
end
