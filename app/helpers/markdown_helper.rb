module MarkdownHelper
  def render_markdown_for page:
    content = File.read [Rails.root, "config/locales/pages/#{I18n.locale}", "#{page}.markdown"].join('/')

    render_markdown content
  end

  def render_markdown text
    return if text.blank?

    Kramdown::Document.new(
      MarkdownMedia.parse(text, include_media: media_mode?),
      input: :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true
    ).to_html.html_safe
  end
<<<<<<< HEAD

  def render_content article
    cache [:article_content, article, lite_mode?] do
      article.content_rendered include_media: media_mode?
    end
  end
=======
>>>>>>> Move #render_markdown to MarkdownHelper
end
