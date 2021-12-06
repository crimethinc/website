class Definition < ApplicationRecord
  include Post
  include Featureable
  include Translatable

  default_scope { unscoped.order(slug: :asc) }

  before_save :set_filed_under
  before_save :set_publication_status

  def path
    "/books/contradictionary/definitions/#{slug}"
  end

  private

  def set_filed_under
    self.filed_under = title[0]&.downcase if title.present?
  end

  def set_publication_status
    draft! if publication_status.blank?
  end
end
