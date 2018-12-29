class PagesController < ApplicationController
  before_action :set_page,       only: [:show]
  before_action :page_redirects, only: [:show]

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
        Page.where(draft_code: params[:draft_code])
      else
        Page.where(slug: params[:path])
      end

    return redirect_to [:root] if @page.blank?

    @page = @page.first
  end

  def page_redirects
    return redirect_to @page.path if @page.published? && params[:draft_code].present?
  end
end
