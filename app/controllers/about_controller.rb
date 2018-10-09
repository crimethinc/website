class AboutController < ApplicationController
  def library
    @html_id = 'page'
    @body_id = 'library'
    @title   = I18n.t('page_titles.about.library')

    @featured_current_events        = Article.find_by(slug: 'feature-report-back-from-the-battle-for-sacred-ground')
    @featured_strategy_and_analysis = Article.find_by(slug: 'feature-understanding-the-kurdish-resistance-historical-overview-eyewitness-report')
    @featured_theory_and_critique   = Article.find_by(slug: 'feature-from-democracy-to-freedom')
    @featured_classics              = Article.find_by(slug: 'why-we-dont-make-demands')
  end

  def post_order_success
    @html_id  = 'page'
    @body_id  = 'store'
    @title    = title_for I18n.t('page_titles.about.store'), I18n.t('page_titles.about.post_order_success')
    @order_id = params[:ordernum]
  end

  # TODO: make this view localizable
  def submission_guidelines
    @html_id = 'page'
    @body_id = 'library'
    @title   = I18n.t('page_titles.about.submission_guidelines')
    @title   = 'Submission Guidelines'
  end
end
