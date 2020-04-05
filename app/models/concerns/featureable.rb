module Featureable
  extend ActiveSupport::Concern

  included do
    scope :featured, -> { where.not(featured_at: nil) }
  end
end
