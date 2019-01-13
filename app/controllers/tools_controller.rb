class ToolsController < ApplicationController
  def about
    @html_id = 'page'
    @body_id = 'tools'
    @type    = 'tools'
    @title   = title_for :tools
  end
end
