class Admin::DashboardController < Admin::AdminController
  before_action :authorize

  # /admin/dashboard
  def index
    @draft_articles  = Article.draft
    @recent_articles = Article.last_2_weeks
    @title           = admin_title
  end
end
