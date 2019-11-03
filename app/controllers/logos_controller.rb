class LogosController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'tools'
    @tools   = Logo.live.published.page(params[:page]).per(100)
    @title   = PageTitle.new title_for :logos
  end

  def show
    @tool = Logo.live.published.where(slug: params[:slug]).first
    return redirect_to [:logos] if @tool.blank?

    @html_id  = 'page'
    @body_id  = 'tools'
    @type     = 'logos'
    @editable = @tool
    @title    = PageTitle.new title_for :logos, @tool.name
  end
end
