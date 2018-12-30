module Post
  extend ActiveSupport::Concern

  include Name
  include Searchable
  include Slug
  include Publishable

  included do
    belongs_to :user, optional: true

    before_validation :generate_draft_code, on: [:create, :update]
  end

  def meta_description
    if summary.blank?
      html = Kramdown::Document.new(
        content,
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.to_s

      doc = Nokogiri::HTML(html)
      doc.css('body').text.truncate(200)
    else
      summary
    end
  end

  def meta_image
    image.presence || t('head.meta_image_url')
  end

  def content_in_html?
    content_format == 'html'
  end

  private

  def generate_draft_code
    self.draft_code ||= SecureRandom.hex
  end
end
