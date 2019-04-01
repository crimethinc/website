class PagesController < ApplicationController
  before_action :set_page,       only: [:show]
  before_action :page_redirects, only: [:show]
  before_action :set_html_id

  def show
    @editable = @page

    # no layout
    render html: @page.content.html_safe, layout: false if @page.content_in_html?
  end

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

  def steal_something_from_work_day
    @title = I18n.t('page_titles.about.steal_something_from_work_day')
    render layout: false
  end

  private

  def set_page
    @page =
      if params[:draft_code].present?
        Page.find_by(draft_code: params[:draft_code])
      else
        Page.find_by(slug: params[:path])
      end

    redirect_to [:root] if @page.blank?
  end

  def page_redirects
    return redirect_to @page.path if @page.published? && params[:draft_code].present?
  end

  def set_html_id
    @html_id = 'page'
  end
end
