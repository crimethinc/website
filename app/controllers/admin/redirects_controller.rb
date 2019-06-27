module Admin
  class RedirectsController < Admin::AdminController
    before_action :set_redirect, only: %i[show edit update destroy]

    def index
      redirects =
        if search_lookup_key.present?
          redirects_filtered_by_search
        else
          Redirect.all
        end

      @redirects = redirects.page(params[:page])
      @title     = admin_title
    end

    def show
      @title = admin_title(@redirect, [:source_path])
    end

    def new
      @redirect = Redirect.new
      @title = admin_title
    end

    def edit
      @title = admin_title(@redirect, %i[id source_path])
    end

    def create
      @redirect = Redirect.new(redirect_params)

      if @redirect.save
        redirect_to [:admin, @redirect], notice: 'Redirect was successfully created.'
      else
        render :new
      end
    end

    def update
      if @redirect.update(redirect_params)
        redirect_to [:admin, @redirect], notice: 'Redirect was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @redirect.destroy
      redirect_to %i[admin redirects], notice: 'Redirect was successfully destroyed.'
    end

    private

    def convert_url_to_path url
      url.strip.sub(%r{https*://}, '').sub(/cwc.im|crimethinc.com/, '')
    end

    def search_lookup_key
      lookup_key = :source_path if params[:source_path].present?
      lookup_key = :target_path if params[:target_path].present?
      lookup_key
    end

    def redirects_filtered_by_search
      searched_query = convert_url_to_path params[search_lookup_key]

      redirects = [
        Redirect.where(search_lookup_key => searched_query),
        Redirect.where(search_lookup_key => "/#{searched_query}")
      ]

      redirects.first.presence || redirects.last
    end

    def set_redirect
      @redirect = Redirect.find(params[:id])
    end

    def redirect_params
      params.require(:redirect).permit(:source_path, :target_path, :temporary)
    end
  end
end
