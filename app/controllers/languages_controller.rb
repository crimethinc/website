class LanguagesController < ApplicationController
  before_action :set_articles, only: :show

  def index
    @html_id = 'page'
    @body_id = 'languages'
    @locales = Locale.all

    render "#{Theme.name}/languages/index"
  end

  def show
    @html_id = 'page'
    @body_id = 'languages'
    @locale  = Locale.find_by(slug: canonical_locale.canonical)

    render "#{Theme.name}/languages/show"
  end

  private

  def canonical_locale
    @canonical_locale ||= LocaleService.find(locale: params[:locale])
  end

  def set_articles
    abbreviation = canonical_locale.lang_code
    @articles = Article.live.published.where(locale: abbreviation).page(params[:page]).per(25)
    return redirect_to root_path if @articles.empty?
  end
end
