module Post
  extend ActiveSupport::Concern

  include Name
  include Searchable
  include Slug
  include Publishable
  include MetaDescription

  included do
    belongs_to :user, optional: true

    before_validation :generate_draft_code, on: [:create, :update]
  end

  def meta_image
    image.presence || t('head.meta_image_url')
  end

  private

  def generate_draft_code
    self.draft_code ||= SecureRandom.hex
  end
end
