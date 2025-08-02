module MarkdownHelper
  def render_markdown_for page:
    content = File.read [Rails.root, "config/locales/pages/#{I18n.locale}", "#{page}.markdown"].join('/')

    render_markdown content
  end

  def render_markdown text, remove_wrapper_p_tag: false
    return if text.blank?

    html = Kramdown::Document.new(
      MarkdownMedia.parse(text, include_media: media_mode?),
      input:                     :kramdown,
      remove_block_html_tags:    false,
      transliterated_header_ids: true,
      header_links:              true
    ).to_html.html_safe

    html = remove_wrapper_p_tag_from html if remove_wrapper_p_tag.present?
    html
  end

  def remove_wrapper_p_tag_from html
    fragment = Nokogiri::HTML5.fragment html
    fragment.inner_html.gsub('<p>', '').gsub('</p>', '').strip.html_safe
  end
end
