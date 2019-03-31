class PagesController < ApplicationController
  before_action :set_page,       only: [:show]
  before_action :page_redirects, only: [:show]
  before_action :set_html_id

  def show
    @html_id = 'page'
    @editable = @page

    # no layout
    render html: @page.content.html_safe, layout: false if @page.content_in_html?
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
