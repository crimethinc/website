class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_for_redirection
  before_action :set_social_links
  before_action :set_new_subscriber
  before_action :set_pinned_pages

  helper :meta

  def set_pinned_pages
    # pinned article
    pinned_to_site_top_page_id      = setting(:pinned_to_site_top_page_id)
    pinned_to_footer_top_page_id    = setting(:pinned_to_footer_top_page_id)
    pinned_to_footer_bottom_page_id = setting(:pinned_to_footer_bottom_page_id)

    if pinned_to_site_top_page_id.present?
      @pinned_to_site_top = Page.find(pinned_to_site_top_page_id)
    end

    if pinned_to_footer_top_page_id.present?
      @pinned_to_footer_top = Page.find(pinned_to_footer_top_page_id)
    end

    if pinned_to_footer_bottom_page_id.present?
      @pinned_to_footer_bottom = Page.find(pinned_to_footer_bottom_page_id)
    end
  end

  def signed_in?
    current_user
  end
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to signin_url, alert: "You need to sign in to view that page." unless signed_in?
  end

  def setting(slug)
    Setting.find_by(slug: slug).try(:content)
  end
  helper_method :setting

  def listing?
    action_name == "index"
  end
  helper_method :listing?

  def showing?
    action_name == "show"
  end
  helper_method :showing?

  def editing?
    action_name == "edit"
  end
  helper_method :editing?

  def creating?
    action_name == "new"
  end
  helper_method :creating?

  def set_social_links
    @social_links = Link.where(user: nil).all
  end

  def set_new_subscriber
    @subscriber = Subscriber.new
  end

  def check_for_redirection
    redirect = Redirect.where(source_path: request.path).last

    if redirect.blank?
      redirect = Redirect.where(source_path: "#{request.path}/").last
    end

    if redirect.present?
      return redirect_to redirect.target_path, status: redirect.temporary? ? 302 : 301
    end
  end

  def render_markdown(text)
    Kramdown::Document.new(
      text,
      input: :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true
    ).to_html.html_safe
  end
  helper_method :render_markdown

  def render_content(post)
    Kramdown::Document.new(
      post.content,
      input: post.content_format == "html" ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end
  helper_method :render_content
end
