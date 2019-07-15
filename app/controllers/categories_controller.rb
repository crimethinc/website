class CategoriesController < ApplicationController
  before_action :set_slug,     only: %i[show feed]
  before_action :set_category, only: %i[show feed]
  before_action :set_title,    only: %i[show feed]
  before_action :set_articles, only: %i[show feed]

  def show
    @html_id = 'page'
    @body_id = 'category'
    @title   = title_for :categories, @category.name
  end

  def index
    @html_id    = 'page'
    @body_id    = 'categories'
    @categories = Category.all
    @title      = title_for :categories
  end

  def feed
    render 'articles/index'
  end

  private

  def set_slug
    @slug = params[:slug].dasherize

    return redirect_to category_path(@slug) if @slug != params[:slug]
  end

  def set_category
    @category = Category.where(slug: @slug)
    return redirect_to [:categories] if @category.blank?

    @category = @category.first
  end

  def set_title
    @title = @category.name
  end

  def set_articles
    @articles = @category.articles.live.published.page(params[:page]).per(25)

    return redirect_to root_path if @articles.blank?
  end
end
