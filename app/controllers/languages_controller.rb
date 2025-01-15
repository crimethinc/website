class LanguagesController < ApplicationController
  before_action :set_articles, only: :show

  def index
    @html_id = 'page'
    @body_id = 'languages'
    @locales = Locale.live
    @title = PageTitle.new t 'header.languages'

    render "#{Current.theme}/languages/index"
  end

  def show
    @html_id = 'page'
    @body_id = 'languages'
    @locale  = Locale.find_by(slug: canonical_locale.canonical)
    @title = PageTitle.new "#{@locale.name} / #{@locale.name_in_english} (#{@locale.slug})"

    @description = []

    unless @locale.abbreviation == Current.locale.to_s
      @description << t('views.languages.view_site_in_locale', locale: @locale.abbreviation)
    end

    @description << t('views.languages.view_tools_in_locale', locale: @locale.abbreviation)
    @description << t('views.languages.view_books_in_locale', locale: @locale.abbreviation)
    @description = @description.join ' '

    render "#{Current.theme}/languages/show"
  end

  private

  def canonical_locale
    @canonical_locale ||= LocaleService.find(locale: params[:locale])
  end

  def set_articles
    abbreviation = canonical_locale&.lang_code
    @articles = Article.live.published.where(locale: abbreviation).page(params[:page]).per(25)
    redirect_to languages_path if @articles.empty?
  end
end
