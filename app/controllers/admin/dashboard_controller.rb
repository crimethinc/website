class Admin::DashboardController < Admin::AdminController
  before_action :authorize

  # /admin/dashboard
  def index
    @draft_articles  = Article.draft
    @recent_articles = Article.last_10_days
    @title           = admin_title
  end
end
