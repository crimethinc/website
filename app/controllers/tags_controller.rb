class TagsController < ApplicationController
  before_action :set_tag
  before_action :set_title
  before_action :set_articles

  def show
    @html_id = 'page'
    @body_id = 'tag'

    render "#{Current.theme}/tags/show"
  end

  def feed
    render "#{Current.theme}/articles/index"
  end

  private

  def set_tag
    @tag = Tag.where(slug: params['slug'])

    return redirect_to :root, allow_other_host: true if @tag.blank?

    @tag = @tag.first
  end

  def set_title
    @title = PageTitle.new @tag.name
  end

  def set_articles
    @articles = @tag.articles.for_index(**filters).page(params[:page]).per(25)

    return redirect_to root_path if @articles.blank?
  end

  def filters
    {}.merge(sort)
      .merge(language_filter)
      .compact
  end

  def sort
    { fallback_sort: { published_at: :desc } }
  end

  def language_filter
    { fallback_locale: filter_params[:lang].presence&.to_s }
  end

  def filter_params
    params.permit(:lang, :format)
  end
end
