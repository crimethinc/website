class PagesController < ApplicationController
  before_action :set_page,       only: [:show]
  before_action :page_redirects, only: [:show]

  def show
    @html_id = "page"
    @editable = @page

    # no layout
    if @page.hide_layout?
      render html: @page.content.html_safe, layout: false
    else
      render "pages/show"
    end
  end

  private

  def set_page
    if params[:draft_code].present?
      @page = Page.find_by(draft_code: params[:draft_code])
    else
      @page = Page.find_by(slug: params[:path])
    end
  end

  def page_redirects
    if @page.nil?
      return redirect_to root_path
    end

    if @page.published? && params[:draft_code].present?
      return redirect_to @page.path
    end
  end
end
