class IssuesController < ToolsController
  # See tools_controller.rb for inherited behavior
  def show
    journal   = Journal.find_by(slug: params[:slug])
    @issue    = Issue.find_by(issue: params[:issue_number], journal_id: journal.id)
    @tool     = @issue
    @editable = @issue
    render 'books/show'
  end
end
