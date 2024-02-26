class PagesController < ApplicationController
  before_action :set_page,       only: %i[show about contact]
  before_action :page_redirects, only: %i[show about contact]
  before_action :set_html_id

  # TODO: Delete? Is this used by anything anymore?
  def show
    @editable = @page
    @title    = PageTitle.new I18n.t("page_titles.about.#{@page.slug}")

    # no layout
    render html: @page.content.html_safe, layout: false if @page.content_in_html?
  end

  def about
    @editable = @page
    @title = PageTitle.new I18n.t('page_titles.about.about')

    render "#{Current.theme}/pages/about"
  end

  def contact
    @editable = @page
    @title = PageTitle.new I18n.t('page_titles.about.contact')

    render "#{Current.theme}/pages/contact"
  end

  def feeds
    @title = PageTitle.new I18n.t('page_titles.about.rss_feeds')

    @locales = Locale.unscoped.order(name_in_english: :asc)

    render "#{Current.theme}/pages/feeds"
  end

  def library
    @title = PageTitle.new I18n.t('page_titles.about.library')

    render "#{Current.theme}/pages/library"
  end

  # TODO: make this view localizable
  def submission_guidelines
    @title = PageTitle.new I18n.t('page_titles.about.submission_guidelines')

    render "#{Current.theme}/pages/submission_guidelines"
  end

  def pgp_public_key
    content = File.read [Rails.root, 'app', 'assets', 'pgp_public_key.asc'].join('/')

    render plain: content
  end

  private

  def set_page
    @page =
      if params[:draft_code].present?
        Page.find_by(draft_code: params[:draft_code])
      else
        Page.find_by(slug: request.path.split('/').last)
      end
  end

  def page_redirects
    return render file: Rails.public_path.join('404.html'), status: :not_found if @page.nil?

    redirect_to @page.path if @page.published? && params[:draft_code].present?
  end

  def set_html_id
    @html_id = 'page'
  end
end
