class Video < ApplicationRecord
  include Name, Publishable, Slug

  def path
    "/videos/#{slug}"
  end

  def content_rendered
    Kramdown::Document.new(
      content,
      input: content_format == "html" ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end
end
