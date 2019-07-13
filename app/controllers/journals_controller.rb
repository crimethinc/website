class JournalsController < ToolsController
  # See tools_controller.rb for inherited behavior
  def index
    @journals = Journal.all.includes(:issues)
  end

  def show
    @journal = Journal.find_by(slug: params[:id])
  end
end
