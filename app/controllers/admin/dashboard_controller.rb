class Admin::DashboardController < Admin::AdminController
  before_action :authorize

  # /admin/dashboard
  def index
    @draft_articles  = Article.draft
    @recent_articles = Article.last_2_weeks
    @title           = admin_title
  end

  # /admin/markdown
  def markdown
    @title    = 'Markdown Cheatsheet'
    @html_id  = 'markdown'
    @body_id  = 'top'
    @sections = [
                  [:headings, :links, :horizontal_rules, :paragraphs],
                  [:lists, :bold_and_italics]
                ]
  end
end
