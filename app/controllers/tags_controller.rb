class TagsController < ApplicationController

  def show
    @tag      = Tag.find_by!(slug: params["slug"])
    @articles = @tag.articles.live.published.page(params[:page]).per(15)

    if @articles.empty?
      return redirect_to root_path
    end

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
