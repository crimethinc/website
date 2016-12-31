module ApplicationHelper

  def render_content(post)
    Kramdown::Document.new(
      post.content,
      input: post.content_format == "html" ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end

  def page_title
    t(:site_name)
  end

  def lang
    # TODO
    "en"
  end

  def html_id
    @html_id
  end

  def body_id
    @body_id
  end

  def author
    t(:site_name)
  end

  def og_type
    "website"
  end

  def twitter_username
    "@crimethinc"
  end

  def twitter_user_id
    "14884161"
  end

  def icon_sizes
    [57, 60, 70, 72, 76, 114, 120, 144, 150, 152, 180, 192, 200, 300, 310, 500, 600]
  end

  def apple_touch_icon_link_tags
    output = []

    # square pixel sizes
    icon_sizes.each do |size|
      dimensions = "#{size}x#{size}"
      href = asset_path("icons/icon-#{dimensions}.png")
      output << tag(:link, rel: "apple-touch-icon icon", sizes: dimensions, href: href)
    end

    output.join("\n").html_safe
  end

  def br_to_p(html)
    simple_format(html, {}, sanitize: false).gsub("\n<br />", "</p><p>").html_safe
  end

  def homepage?
    @homepage = true
  end
end
