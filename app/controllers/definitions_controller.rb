class DefinitionsController < ApplicationController
  before_action :set_book
  before_action :set_definition, only: %i[show]

  def index
    @html_id = 'definitions'
    @body_id = 'article'
    @title   = PageTitle.new title_for(:definitions)

    @definitions = Definition.live.published.group_by(&:filed_under)

    render "#{Current.theme}/definitions/index"
  end

  def letter
    @html_id = 'definitions'
    @body_id = 'article'
    @title   = PageTitle.new title_for(:definitions)
    @letter  = params[:letter]

    @definitions = Definition.live.published.where(filed_under: params[:letter])

    return redirect_to :definitions if @definitions.blank?

    render "#{Current.theme}/definitions/letter"
  end

  def show
    @html_id    = 'definitions'
    @body_id    = 'article'
    @editable   = @definition
    @definition = Definition.find_by(slug: params[:slug])
    @title      = PageTitle.new title_for(:definitions, @definition.slug.underscore)

    render "#{Current.theme}/definitions/show"
  end

  private

  def set_book
    @book = Book.find_by(slug: 'contradictionary')
  end

  def set_definition
    @definition = Definition.find_by(slug: params[:slug])
    return redirect_to [:definitions] if @definition.blank?
  end
end
