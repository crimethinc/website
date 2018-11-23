module MarkdownHelper
  def render_markdown_for page:
    content = File.read [Rails.root, "config/locales/pages/#{I18n.locale}", "#{page}.markdown"].join('/')

    render_markdown content
  end
end
