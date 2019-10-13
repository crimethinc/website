class ZinesController < ToolsController
  # See tools_controller.rb for inherited behavior
  def show
    render "#{Theme.name}/books/show"
  end
end
