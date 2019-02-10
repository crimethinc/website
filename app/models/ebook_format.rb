class EbookFormat
  class << self
    def all
      I18n.t('ebooks').map { |ebook_format| new_ebook_format_for ebook_format }
    end

    private

    def new_ebook_format_for ebook_format
      Struct.new(:slug, :name, :description).new(
        ebook_format[:slug],
        ebook_format[:name],
        ebook_format[:description]
      )
    end
  end
end
