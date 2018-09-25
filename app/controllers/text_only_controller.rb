class TextOnlyController < ApplicationController
  def home
    @title = 'CrimthInc. Text-Only | Home'
    @articles = Article.includes(:categories, :status).live.published.root.page(params[:page]).per(7)
  end

  def article
    @article = Article.find(params[:id])
    @title = "CrimthInc. Text-Only | #{@article.title}"
  end

  def render_text_only(post)
    return if post.content.blank?

    # getting rid of image embed tags and turning newlines into full breaks
    html = Kramdown::Document.new(
      post.content.gsub(MarkdownMedia::EMBED_REGEX, '').gsub("\n", "\n\n"),
      input: post.content_format == 'html' ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe

    if post.content_format == 'html'
      doc = Nokogiri::HTML(html)
      doc.search('img').each do |img|
        img.remove
      end
      html = doc.to_html.html_safe
    end

    html
  end
  helper_method :render_text_only
end
