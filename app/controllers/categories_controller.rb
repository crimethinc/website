class CategoriesController < ApplicationController
  before_action :set_slug,     only: %i[show feed]
  before_action :set_category, only: %i[show feed]
  before_action :set_title,    only: %i[show feed]
  before_action :set_articles, only: %i[show feed]

  def index
    @html_id    = 'page'
    @body_id    = 'categories'
    @categories = Category.all
    @title      = PageTitle.new title_for(:categories)

    render "#{Current.theme}/categories/index"
  end

  def show
    @html_id = 'page'
    @body_id = 'category'

    render "#{Current.theme}/categories/show"
  end

  def feed
    render "#{Current.theme}/articles/index"
  end

  private

  def set_slug
    @slug = params[:slug].dasherize

    redirect_to category_path(@slug) if @slug != params[:slug]
  end

  def set_category
    @category = Category.where(slug: @slug)
    return redirect_to [:categories] if @category.blank?

    @category = @category.first
  end

  def set_title
    @title = PageTitle.new [title_for(:categories), @category.name]
  end

  def set_articles
    @articles = @category.articles.for_index(**filters).page(params[:page]).per(25)

    redirect_to root_path if @articles.blank?
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
