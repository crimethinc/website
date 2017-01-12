class TagsController < ApplicationController

  def show
    @tag      = Tag.find_by!(slug: params["slug"])
    @articles = @tag.articles

    @html_id  = "page"
    @body_id  = "tag"
    @title    = @tag.name
  end

end
