require 'open-uri'
require 'json'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale_from_subdomain
  before_action :set_site_locale
  before_action :check_for_redirection
  before_action :strip_file_extension
  before_action :authorize, if: :staging?
  before_action :set_page_share

  helper :meta

  def staging?
    ENV['ON_STAGING'] == 'TRUE'
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
    current_user
  end
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to [:signin], alert: 'You need to sign in to view that page.' unless signed_in?
  end

  def live_locales
    return @live_locales if @live_locales.present?

    @live_locales = Locale.all

    @live_locales.each do |locale|
      locale.articles_count = Article.live.published.where(locale: locale.abbreviation).count
    end

    @live_locales = @live_locales
                    .reject { |locale| locale.articles_count.zero? }
                    .sort_by(&:articles_count)
                    .reverse
  end
  helper_method :live_locales

  def set_locale_from_subdomain
    locale = request.subdomain
    I18n.locale = locale if I18n.available_locales.include?(locale.to_sym)

    # Force the subdomain to match the locale.
    # Don’t do this in development, because typically local development
    # environments don’t support subdomains (en.localhost doesn’t resolve).
    if (I18n.locale != I18n.default_locale) && # Don’t redirect to en.crimethinc.com
       request.subdomain.empty? &&             # Don’t redirect if there’s a subdomain
       Rails.env.production?                   # Don’t redirect in development

      redirect_to({ subdomain: I18n.locale }.merge(params.permit!))
    end
  end

  def check_for_redirection
    redirect = Redirect.where(source_path: request.path.downcase).last
    redirect = Redirect.where(source_path: "#{request.path.downcase}/").last if redirect.blank?

    return redirect_to(redirect.target_path.downcase, status: redirect.temporary? ? 302 : 301) if redirect.present?
  end

  # TODO: move to rack middleware
  def strip_file_extension
    return redirect_to request.path.sub(/\.html/, '') if /\.html/.match?(request.path)
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
      pieces << (piece.match?(/translation missing/) ? key : piece)
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
    'https://cloudfront.crimethinc.com/assets/share/crimethinc-site-share.png'
  end

  def set_site_locale
    @site_locale = LocaleService.find(locale: nil, lang_code: I18n.locale)
  end

  # ...Page Share
end
