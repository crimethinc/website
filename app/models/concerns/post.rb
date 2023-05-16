module Post
  extend ActiveSupport::Concern

  include Name
  include Slug
  include Publishable
  include MetaDescription

  included do
    belongs_to :user, optional: true

    before_validation :generate_draft_code, on: %i[create update]
  end

  def meta_image
    image.presence || I18n.t('head.meta_image_url')
  end

  def content_in_html?
    content_format == 'html'
  end

  private

  def generate_draft_code
    self.draft_code ||= SecureRandom.hex
  end
end
