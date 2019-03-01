module Admin
  class LocalesController < Admin::AdminController
    before_action :set_locale, only: [:show, :edit, :update, :destroy]

    def index
      @locales = Locale.page(params[:page]).per(100)
      @title   = admin_title
    end

    def show
      redirect_to [:admin, :locales]
    end

    def new
      @locale = Locale.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@locale, [:id, :source_path])
    end

    def create
      @locale = Locale.new(locale_params)

      if @locale.save
        redirect_to [:admin, :locales], notice: 'Locale was successfully created.'
      else
        render :new
      end
    end

    def update
      if @locale.update(locale_params)
        redirect_to [:admin, :locale], notice: 'Locale was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @locale.destroy
      redirect_to [:admin, :locales], notice: 'Locale was successfully destroyed.'
    end

    private

    def set_locale
      @locale = Locale.find(params[:id])
    end

    def locale_params
      params.require(:locale).permit(:abbreviation, :name, :name_in_english)
    end
  end
end
