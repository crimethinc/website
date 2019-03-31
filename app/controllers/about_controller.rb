class AboutController < ApplicationController
  before_action :set_html_id

  def library
    @title = I18n.t('page_titles.about.library')
  end

  def post_order_success
    @title    = title_for I18n.t('page_titles.about.store'), I18n.t('page_titles.about.post_order_success')
    @order_id = params[:ordernum]
  end

  # TODO: make this view localizable
  def submission_guidelines
    @title = I18n.t('page_titles.about.submission_guidelines')
    @title = 'Submission Guidelines'
  end

  private

  def set_html_id
    @html_id = 'page'
  end
end
