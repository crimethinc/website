class PageTitle
  class << self
    def with
      # text: nil, path: nil
      I18n.t :site_name
    end
  end
end
