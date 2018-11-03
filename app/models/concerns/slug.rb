module Slug
  extend ActiveSupport::Concern

  included do
    before_validation :blank_slug,    on: [:create, :update]
    before_validation :generate_slug, on: [:create, :update]
  end

  def slug_exists?
    self.class.where(slug: slug).exists?
  end

  def blank_slug
    return unless is_a?(Article) || is_a?(Page)

    self.slug = nil if publication_status.blank? || (publication_status.present? && !published?)
  end

  def generate_slug
    if new_record? || slug_changed? || slug.blank?
      n = 0

      self.slug = name&.to_slug if slug.blank?

      while slug_exists?
        n += 1
        self.slug = "#{name} #{n}"&.to_slug
      end
    end

    self.slug = slug&.to_slug
  end
end
