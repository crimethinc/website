class ZinesController < ToolsController
  # See tools_controller.rb for inherited behavior
  def show
    render "#{Current.theme}/books/show"
  end
end
