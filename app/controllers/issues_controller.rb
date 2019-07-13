class IssuesController < ToolsController
  # See tools_controller.rb for inherited behavior
  def show
    @issue = Journal.find_by(slug: params[:slug]).issues.find_by(issue: params[:issue_number])
  end
end
