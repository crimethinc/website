class AboutController < ApplicationController
  def start
    @html_id = "page"
    @body_id = "start"
  end

  def read
    @html_id = "page"
    @body_id = "read"

    @featured_current_events        = Article.find_by(slug: "feature-report-back-from-the-battle-for-sacred-ground")
    @featured_strategy_and_analysis = Article.find_by(slug: "feature-understanding-the-kurdish-resistance-historical-overview-eyewitness-report")
    @featured_theory_and_critique   = Article.find_by(slug: "feature-from-democracy-to-freedom")
    @featured_classics              = Article.find_by(slug: "why-we-dont-make-demands")
  end

  def watch
    @html_id = "page"
    @body_id = "watch"

    @videos  = Video.all
  end

  def listen
    @html_id = "page"
    @body_id = "listen"
  end
end
