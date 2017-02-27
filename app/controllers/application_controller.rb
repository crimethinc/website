require "open-uri"
require "json"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :strip_www
  before_action :check_for_redirection
  before_action :strip_file_extension
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

  def strip_file_extension
    if request.path =~ /\.html/
      return redirect_to request.path.sub(/\.html/, "")
    end
  end

  def strip_www
    # TODO fix this with DNS instead in every request
    if request.host =~ /www\.crimethinc/
      url = request.protocol + request.host.sub(/www\./, "") + request.path
      return redirect_to url
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
      expanded_embeds(post).content,
      input: post.content_format == "html" ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end
  helper_method :render_content

  def expanded_embeds(post)
    embed_regex = /\[\[\s*(http[^\]\s]+(?:\s.+)?)\s*\]\]/

    output_content = post.content.gsub(embed_regex) do |match|
      embed_tag = $1

      if embed_tag.present?
        embed_tag_pieces = embed_tag.split(" ")

        url     = embed_tag_pieces.shift
        id      = remove_id(embed_tag_pieces)
        link    = if embed_tag_pieces.present?
          embed_tag_pieces.pop if url_or_path?(embed_tag_pieces.last)
        end
        caption = embed_tag_pieces.join(" ")

        expanded_embed(url, caption: caption, link: link, id: id)
      end
    end

    post.content = output_content
    post
  end
  helper_method :expanded_embeds

  def expanded_embed(url, caption: nil, link: nil, id: nil)
    url  = URI.parse(url)

    case url.host
    when /youtube.com/
      slug     = "youtube"
      embed_id = nil

      url.query.split("&").each do |key_value_pair|
        argument, value = key_value_pair.split("=")
        if argument == "v"
          embed_id = value
        end
      end

    when "youtu.be"
      slug     = "youtube"
      embed_id = url.path.split("/").map{ |path_piece| path_piece unless path_piece.blank? }.compact.first

    when "vimeo.com"
      slug     = "vimeo"
      embed_id = url.path.split("/").map{ |path_piece| path_piece unless path_piece.blank? }.compact.first

    when "twitter.com"
      slug     = "twitter"

    else
      slug = case url.path

      when /\.mp3|\.aac|\.wav|\.ogg|\.oga|\.m4a/
        "audio"
      when /\.mp4|\.avi|\.mov|\.ogv|\.webm|\.m4v|\.3gp|\.m3u8/
        "video"
      when /\.png|\.jpeg|\.jpg|\.gif|\.svg/
        "image"
      else
        "link"
      end
    end

    render_to_string partial: "/articles/embeds/#{slug}.html.erb", locals: { embed_id: embed_id || url, caption: caption, link: link, id: id }
  end
  helper_method :expanded_embed

  def url_or_path?(string)
    string.match?(/^(http|\/)\S+/)
  end

  def remove_id(pieces)
    id_string = pieces.detect { |piece| piece =~ /id:\S+/ }

    if id_string
      id = id_string.split(":").last
      pieces.delete(id_string)

      id
    end
  end
end
