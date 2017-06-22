class ToolsController < ApplicationController
  before_action :set_type,   only: [:index, :show]
  before_action :allow_only, only: [:index, :show]
  before_action :set_slug,   only: [:index, :show]
  before_action :set_tools,  only: [:index]
  before_action :set_tool,   only: [:show]
  before_action :set_title,  only: [:index, :show]

  def index
    @html_id = "page"
    @body_id = "tools"
  end

  private

  def set_type
    @type = params[:type] || "tools"
  end

  def allow_only
    unless request.path == "/tools" || %w(posters stickers zines).include?(@type.downcase)
      return redirect_to [:tools]
    end
  end

  def set_slug
    @slug = params[:slug]
  end

  def set_tools
    @tools = case @type
    when "posters"
      Poster.poster.all
    when "stickers"
      Poster.sticker.all
    when "zines"
      Book.zine.all
    end
  end

  def set_tool
    @tool = case @type
    when "posters"
      Poster.find_by(slug: @slug, poster: true)
    when "stickers"
      Poster.find_by(slug: @slug, sticker: true)
    when "zines"
      Book.find_by(slug: @slug, zine: true)
    end
  end

  def set_title
    @title = [@type.capitalize, @tool&.title].join(" : ")
  end
end
