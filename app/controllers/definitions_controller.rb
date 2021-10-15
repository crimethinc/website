class DefinitionsController < ApplicationController
  before_action :set_definition, only: %i[show]

  def index
    @html_id = 'page'
    @body_id = 'definitions'
    @title   = PageTitle.new title_for(:definitions)

    @definitions = Definition.live.published

    render "#{Current.theme}/definitions/index"
  end

  def show
    @html_id    = 'page'
    @body_id    = 'tools'
    @type       = 'definitions'
    @editable   = @definition
    @definition = Definition.find_by(slug: params[:slug])
    @title      = PageTitle.new title_for(:definitions, @definition.slug.underscore)

    render "#{Current.theme}/definitions/show"
  end

  private

  def set_definition
    @definition = Definition.find_by(slug: params[:slug])
    return redirect_to [:definitions] if @definition.blank?
  end
end
