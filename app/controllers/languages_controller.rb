class LanguagesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'languages'
    @locales = Locale.all

    render "#{Theme.name}/languages/index"
  end

  def show
    @html_id = 'page'
    @body_id = 'languages'
    @locale  = Locale.find_by slug: canonical_locale_slug

    render "#{Theme.name}/languages/show"
  end

  private

  def canonical_locale_slug
    LocaleService.find(locale: params[:locale]).canonical
  end
end
