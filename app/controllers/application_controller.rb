require 'open-uri'
require 'json'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_for_redirection
  before_action :strip_file_extension
  before_action :authorize, if: :staging?

  helper :meta

  def staging?
    ENV['ON_STAGING'] == 'TRUE'
  end
  helper_method :staging?

  def signed_in?
    current_user
  end
  helper_method :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to signin_url, alert: 'You need to sign in to view that page.' unless signed_in?
  end

  def listing?
    action_name == 'index'
  end
  helper_method :listing?

  def showing?
    action_name == 'show'
  end
  helper_method :showing?

  def editing?
    action_name == 'edit'
  end
  helper_method :editing?

  def creating?
    action_name == 'new'
  end
  helper_method :creating?

  def check_for_redirection
    redirect = Redirect.where(source_path: request.path.downcase).last

    if redirect.blank?
      redirect = Redirect.where(source_path: "#{request.path.downcase}/").last
    end

    if redirect.present?
      return redirect_to redirect.target_path.downcase, status: redirect.temporary? ? 302 : 301
    end
  end

  def strip_file_extension
    if request.path =~ /\.html/
      return redirect_to request.path.sub(/\.html/, '')
    end
  end

  def current_resource_name
    request.path.split('admin/').last.split('/').first.capitalize.singularize
  end
  helper_method :current_resource_name

  def render_markdown(text)
    unless text.blank?
      Kramdown::Document.new(
        MarkdownMedia.parse(text),
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.html_safe
    end
  end
  helper_method :render_markdown

  def render_content(post)
    cache post do
      post.content_rendered
    end
  end
  helper_method :render_content

  def meta_title(thing = nil)
    thing.present? ? thing.title : t('head.meta_title')
  end
  helper_method :meta_title

  def page_title
    if @title.present?
      t(:site_name) + prepend_admin_if_needed + @title
    else
      t(:site_name)
    end
  end
  helper_method :page_title

  def prepend_admin_if_needed
    if controller_path.match(/\Aadmin\/.*\z/).present?
      " #{t('admin.title_prepend')} : "
    else
      ' : '
    end
  end
  helper_method :prepend_admin_if_needed

  def author
    t(:site_author)
    # TODO make this article author aware
  end
  helper_method :author

  def root_url
    Rails.env.development? ? 'http://localhost:3000' : 'https://crimethinc.com'
  end
  helper_method :root_url
end
