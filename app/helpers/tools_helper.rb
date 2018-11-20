module ToolsHelper
  def link_to_tool tool:, type:
    link_to text_for_tool_link(type: type, tool: tool),
            [tool],
            class: classes_for_tool_link(type: type),
            target: link_target_for_tool(tool: tool)
  end

  def text_for_tool_link type:, tool:
    return "#{t "views.products.buttons.browse_#{tool}_text"} →" if type == :button

    # tool.capitalize
    t "footer.nav.tools.#{tool}"
  end

  def classes_for_tool_link type:
    'download button' if type == :button
  end

  def link_target_for_tool tool:
    '_blank' if tool == :music
  end
end
