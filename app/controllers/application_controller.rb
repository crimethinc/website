require 'open-uri'
require 'json'

class ApplicationController < ActionController::Base
  # TODO: investigate/test/consider this. Added in Rails 7.2
  # Allow only browsers natively supporting webp images, web push, badges, import maps, CSS nesting + :has
  # allow_browser versions: :modern

  protect_from_forgery with: :exception

  before_action :set_current_locale
  before_action :set_current_theme

  before_action :set_site_locale
  before_action :check_for_redirection
  before_action :strip_file_extension
  before_action :authorize, if: :staging?
  before_action :set_page_share

  helper :meta

  def staging?
    ENV.fetch('ON_STAGING') { 'FALSE' } == 'TRUE'
  end
  helper_method :staging?

  def lite_mode?
    request.subdomain == 'lite'
  end
  helper_method :lite_mode?

  def media_mode?
    !lite_mode?
  end
  helper_method :media_mode?

  def render_content article
    cache [:article_content, article, lite_mode?] do
      article.content_rendered include_media: media_mode?
    end
  end
  helper_method :render_content

  def signed_in?
    Current.user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :signed_in?

  def authorize
    redirect_to [:signin], alert: 'You need to sign in to view that page.' unless signed_in?
  end

  def set_current_locale
    locale = request.subdomain
    I18n.locale = locale if I18n.available_locales.include?(locale.to_sym)

    # Force the subdomain to match the locale.
    # Don’t do this in development, because typically local development
    # environments don’t support subdomains (en.localhost doesn’t resolve).
    if (I18n.locale != I18n.default_locale) && # Don’t redirect to en.crimethinc.com
       request.subdomain.empty? &&             # Don’t redirect if there’s a subdomain
       Rails.env.production?                   # Don’t redirect in development

      redirect_to({ subdomain: I18n.locale }.merge(params.permit!), allow_other_host: true)
    end
  end

  def set_current_theme
    Current.theme = ENV.fetch('THEME') { '2017' }
  end

  def check_for_redirection
    redirect = Redirect.where(source_path: [request.path.downcase, "#{request.path.downcase}/"]).last if redirect.blank?

    return if redirect.blank?

    redirect_to(redirect.target_path, status: redirect.temporary? ? 302 : 301, allow_other_host: true)
  end

  # TODO: move to rack middleware
  def strip_file_extension
    redirect_to request.path.sub('.html', '') if request.path.include?('.html')
  end

  # TODO: move to meta helper
  def current_resource_name
    request.path.split('admin/').last.split('/').first.capitalize.singularize
  end
  helper_method :current_resource_name

  def title_for *page_keys
    pieces = []

    if page_keys.first.is_a? Symbol
      namespace = page_keys.shift
      page_keys.unshift :index
    end

    page_keys.each do |key|
      piece = I18n.t("page_titles.#{namespace}.#{key}")

      if piece.include?('translation missing')
        word_spaced_pieces = Array(key).join(' ')
        piece = String(word_spaced_pieces).humanize.titleize
      end

      pieces << piece
    end

    pieces.flatten.join ' : '
  end

  # TODO: move to a helper
  def author
    t(:site_author)
  end
  helper_method :author

  def root_url
    Rails.env.development? ? 'http://localhost:3000' : 'https://crimethinc.com'
  end
  helper_method :root_url

  # Page Share...
  def set_page_share
    @page_share = PageShare.new url:       page_share_url,
                                title:     page_share_title,
                                subtitle:  page_share_subtitle,
                                content:   page_share_content,
                                image_url: page_share_image_url
  end

  private

  def page_share_url
    # TODO: implement this algorithm
    request.url
    'https://crimethinc.com'
  end

  def page_share_title
    # TODO: implement this algorithm
    'TODO: Page Title That Will be Pre-populated in Form on Each Site'
  end

  def page_share_subtitle
    # TODO: implement this algorithm
    'TODO: And Its Related Subtitle'
  end

  def page_share_content
    # TODO: implement this algorithm
    'TODO: Page summary / description / tweet'
  end

  def page_share_image_url
    # TODO: implement this algorithm
    'https://cdn.crimethinc.com/assets/share/crimethinc-site-share.png'
  end

  def set_site_locale
    @site_locale = LocaleService.find(locale: nil, lang_code: I18n.locale)
  end

  # ...Page Share
end
