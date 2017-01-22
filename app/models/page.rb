class Page < ApplicationRecord
  include Post

  default_scope { order("published_at DESC") }

  def path
    if self.published?
      "/#{self.slug}"
    else
      "/drafts/pages/#{self.draft_code}"
    end
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
