class ToolsController < ApplicationController
  ALL_TOOLS = %w[tools books zines journals posters stickers videos].freeze

  before_action :set_html_id
  before_action :set_body_id
  before_action :set_type

  before_action :set_tool,           except: :about
  before_action :set_featured_tools, except: :about
  before_action :set_tools,          except: :about

  before_action :set_title
  before_action :set_editable, only: :show

  before_action :redirect_to_tool_namespace_if_no_tool, only: :show

  # GET /tools
  def about; end

  def index
    render 'tools/index'
  end

  def show
    render 'tools/show'
  end

  private

  def set_html_id
    @html_id = 'page'
  end

  def set_body_id
    @body_id = 'tools'
  end

  def tools
    tool_class.order(published_at: :desc).live.published
  end

  def set_featured_tools
    @featured_tools = tools.where.not(buy_url: nil).map { |tool| tool if tool.buy_url.present? }.compact
  end

  def set_tools
    @tools = tools.map { |tool| tool if tool.buy_url.blank? }.compact
  end

  def tool_class
    return unless ALL_TOOLS.include? request_namespace

    @tool_class ||= request_namespace.classify.constantize
  end

  def request_namespace
    request.path.split('/')[1]
  end

  def set_type
    @type = tool_class.to_s.tableize
  end

  def set_tool
    @tool = tool_class.live.published.where(slug: params[:slug]).first
  end

  def set_title
    @title = PageTitle.new title_for [@type.capitalize.to_sym, @tool&.name].compact
  end

  def set_editable
    @editable = @tool
  end

  def redirect_to_tool_namespace_if_no_tool
    return redirect_to [@type] if @tool.blank?
  end
end
