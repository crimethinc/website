module ToolsHelper
  def link_to_tool tool:, type:
    link_to text_for_tool_link(type: type, tool: tool),
            [tool],
            class:  classes_for_tool_link(type: type),
            target: link_target_for_tool(tool: tool)
  end

  def text_for_tool_link type:, tool:
    return "#{t "views.tools.buttons.browse_#{tool}_text"} →" if type == :button

    t("footer.nav.tools.#{tool}").capitalize
  end

  def classes_for_tool_link type:
    'download button' if type == :button
  end

  def link_target_for_tool tool:
    '_blank' if tool == :music
  end

  def link_to_definition_letter definition
    link_to definition.filed_under.upcase, [:letter, { letter: definition.filed_under.to_sym }]
  end
end
