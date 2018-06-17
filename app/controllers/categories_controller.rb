class CategoriesController < ApplicationController
  before_action :set_slug,     only: [:show, :feed]
  before_action :set_category, only: [:show, :feed]
  before_action :set_title,    only: [:show, :feed]
  before_action :set_articles, only: [:show, :feed]

  def show
    @html_id  = 'page'
    @body_id  = 'category'
  end

  def index
    @html_id    = 'page'
    @body_id    = 'categories'
    @title      = 'Categories'
    @categories = Category.all
  end

  def feed
    render 'articles/index'
  end

  private

  def set_slug
    @slug = params[:slug].tr('_', '-')

    return redirect_to category_path(@slug) if @slug != params[:slug]
  end

  def set_category
    @category = Category.where(slug: @slug)

    if @category.blank?
      return redirect_to [:categories]
    else
      @category = @category.first
    end
  end

  def set_title
    @title = @category.name
  end

  def set_articles
    @articles = @category.articles.live.published.page(params[:page]).per(25)

    return redirect_to root_path if @articles.blank?
  end
end
