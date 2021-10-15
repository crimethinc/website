class DefinitionsController < ApplicationController
  def show
    @definition = Definition.find_by(slug: params[:slug])
    render "#{Current.theme}/definitions/show"
  end

  def index
    @definitions = Definition.published
    render "#{Current.theme}/definitions/index"
  end
end
