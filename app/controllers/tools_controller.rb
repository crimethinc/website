class ToolsController < ApplicationController
  ALL_TOOLS = %w[tools books zines journals posters stickers videos].freeze

  before_action :set_html_id
  before_action :set_body_id
  before_action :set_type

  before_action :set_tool,  except: %i[about random]
  before_action :set_tools, except: %i[about random]

  before_action :set_title
  before_action :set_editable, only: :show

  before_action :redirect_to_tool_namespace_if_no_tool, only: :show

  # GET /tools
  def about
    render "#{Current.theme}/tools/about"
  end

  # Inherited by each kind of tool
  def index
    render "#{Current.theme}/tools/index"
  end

  # Inherited by each kind of tool
  def show
    @preview_width = 400
    render "#{Current.theme}/tools/show"
  end

  def random
    redirect_to RandomTool.sample.path
  end

  private

  def set_html_id
    @html_id = 'page'
  end

  def set_body_id
    @body_id = 'tools'
  end

  def set_tools
    @tools = tool_class.for_index(**filters).page(params[:page]).per(10)
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
    params.permit(:lang)
  end

  def tool_class
    return unless ALL_TOOLS.include? request_namespace

    @tool_class ||= request_namespace.classify.constantize
  end

  def request_namespace
    controller_path
  end

  def set_type
    @type = tool_class.to_s.tableize
  end

  def set_tool
    @tool = tool_class.live.published.where(slug: params[:slug]).first
  end

  def set_title
    @title = PageTitle.new [title_for(@type.to_sym), @tool&.name].compact
  end

  def set_editable
    @editable = @tool
  end

  def redirect_to_tool_namespace_if_no_tool
    redirect_to [@type.to_sym] if @tool.blank?
  end
end
