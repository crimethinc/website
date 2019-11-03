class PageTitle
  class << self
    def with text: nil, path: nil
      prefix = I18n.t :site_name
      suffix = text || path_pieces(path)

      [prefix, suffix].flatten.compact.join ' : '
    end

    private

    def path_pieces path
      String(path).split('/').map(&:capitalize)
    end
  end
end
