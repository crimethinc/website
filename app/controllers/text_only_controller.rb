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

    Kramdown::Document.new(
      post.content.gsub(MarkdownMedia::EMBED_REGEX, '').gsub("\n", "\n\n"),
      input: post.content_format == 'html' ? :html : :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end
  helper_method :current_user
end
