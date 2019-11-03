class PageTitle
  class << self
    def with text: nil
      # , path: nil
      title = []

      title << I18n.t(:site_name)
      title << text

      title.compact.join ' : '
    end
  end
end
