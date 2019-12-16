class LanguagesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'languages'
    @locales = Locale.all
  end

  def show
    @html_id = 'page'
    @body_id = 'languages'
    @locale  = Locale.find_by slug: params[:locale]
  end
end
