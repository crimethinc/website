class TagsController < ApplicationController
  before_action :set_tag
  before_action :set_title
  before_action :set_articles

  def show
    @html_id = 'page'
    @body_id = 'tag'
  end

  def feed
    render 'articles/index'
  end

  private

  def set_tag
    @tag = Tag.where(slug: params['slug'])

    if @tag.present?
      @tag = @tag.first
    else
      return redirect_to [:root]
    end
  end

  def set_title
    @title = @tag.name
  end

  def set_articles
    @articles = @tag.articles.live.published.page(params[:page]).per(25)
    return redirect_to root_path if @articles.empty?
  end
end
