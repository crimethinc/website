class TagsController < ApplicationController

  def show
    @tag = Tag.find_by(slug: params["slug"])
    return redirect_to root_path if @tag.blank?

    @articles = @tag.articles.live.published.page(params[:page]).per(15)
    return redirect_to root_path if @articles.empty?

    @html_id  = "page"
    @body_id  = "tag"
    @title    = @tag.name
  end

  def feed
    @tag      = Tag.find_by!(slug: params["slug"])
    @articles = @tag.articles.live.published.page(params[:page]).per(25)

    @title    = @tag.name

    render "articles/index"
  end

end
