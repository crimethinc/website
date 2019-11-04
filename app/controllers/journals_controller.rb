class JournalsController < ToolsController
  # See tools_controller.rb for inherited behavior
  def index
    @journals = Journal.includes(:issues)
    render "#{Theme.name}/journals/index"
  end

  def show
    @journal = Journal.find_by(slug: params[:id])
    render "#{Theme.name}/journals/show"
  end
end
