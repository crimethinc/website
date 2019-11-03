require 'rails/html/sanitizer'

class PageTitle
  attr_reader :text, :path

  def initialize text = nil, path: nil
    @text = text
    @path = path
  end

  def content
    prefix = I18n.t :site_name
    suffix = text || path_pieces(path)

    title = [prefix, suffix].flatten.compact.join ' : '

    Rails::Html::FullSanitizer.new.sanitize title
  end

  private

  def path_pieces path
    String(path).split('/').map(&:capitalize)
  end
end
