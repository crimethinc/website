class IssuesController < ApplicationController
  before_action :set_html_id
  before_action :set_body_id

  def show
    @type = 'issues'
    journal   = Journal.find_by(slug: show_params[:slug])
    @issue    = Issue.find_by(issue: show_params[:issue_number], journal_id: journal.id)
    @tool     = @issue
    @editable = @issue

    @title = PageTitle.new title_for :journals, journal.name, @issue.issue
    render "#{Current.theme}/books/show"
  end

  private

  def set_html_id
    @html_id = 'page'
  end

  def set_body_id
    @body_id = 'tools'
  end

  def show_params
    params.permit(:slug, :issue_number)
  end
end
