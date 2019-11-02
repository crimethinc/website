module MarkdownHelper
  def render_markdown_for page:
    content = File.read [Rails.root, "config/locales/pages/#{I18n.locale}", "#{page}.markdown"].join('/')

    render_markdown content
  end

  def render_markdown markdown, remove_wrapper_paragraph_tags: false
    return if markdown.blank?

    html = Kramdown::Document.new(
      MarkdownMedia.parse(markdown, include_media: media_mode?),
      input:                     :kramdown,
      remove_block_html_tags:    false,
      transliterated_header_ids: true
    ).to_html.html_safe

    remove_wrapper_paragraph_tags ? html : remove_wrapper_paragraph_tag(html).html_safe

    html
  end

  def remove_wrapper_paragraph_tag html
    html_doc = Nokogiri::HTML(html.chomp)

    outer_paragraph = html_doc.css('html body p:first')

    if outer_paragraph.present?
      outer_paragraph.first.inner_html
    else
      html
    end
  end
end
