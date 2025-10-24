module Admin
  class LocalesController < Admin::AdminController
    before_action :set_locale, only: %i[show edit update destroy]

    def index
      @locales = Locale.page(params[:page]).per(100)
      @title   = admin_title
    end

    def show
      redirect_to %i[admin locales]
    end

    def new
      @locale = Locale.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@locale, %i[id name abbreviation name_in_english])
    end

    def create
      @locale = Locale.new(locale_params)

      if @locale.save
        redirect_to %i[admin locales], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      if @locale.update(locale_params)
        redirect_to %i[admin locale], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      @locale.destroy
      redirect_to %i[admin locales], notice: t('.notice')
    end

    private

    def set_locale
      @locale = Locale.find(params[:id])
    end

    def locale_params
      params.expect locale: %i[abbreviation name name_in_english language_direction]
    end
  end
end
