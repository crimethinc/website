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
    if self.is_a?(Article) || self.is_a?(Page)
      self.slug = nil if self.status.blank? || (self.status.present? && !published?)
    end
  end

  def generate_slug
    if self.new_record? || self.slug_changed? || self.slug.blank?
      n = 0

      self.slug = self.name&.to_slug if slug.blank?

      while slug_exists?
        n += 1
        self.slug = "#{name} #{n}"&.to_slug
      end
    end

    self.slug = self.slug&.to_slug
  end
end
