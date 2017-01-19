class AboutController < ApplicationController
  def read
    @html_id = "page"
    @body_id = "read"

    @featured_current_events        = Article.find_by(slug: "feature-report-back-from-the-battle-for-sacred-ground")
    @featured_strategy_and_analysis = Article.find_by(slug: "feature-understanding-the-kurdish-resistance-historical-overview-eyewitness-report")
    @featured_theory_and_critique   = Article.find_by(slug: "feature-from-democracy-to-freedom")
    @featured_classics              = Article.find_by(slug: "why-we-dont-make-demands")
  end

  def post_order_success
    @html_id = "page"
    @body_id = "store"
    @title   = "Post-Order Glow"
    @order_id = params[:ordernum]
  end
end
