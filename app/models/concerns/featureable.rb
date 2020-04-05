module Featureable
  extend ActiveSupport::Concern

  included do
    scope :featured, -> { where.not(featured_at: nil) }
    before_save :update_featured_at
  end

  def update_featured_at
    self.featured_at = featured_status? ? Time.current : nil
  end
end
