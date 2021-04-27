class Definition < ApplicationRecord
  include Post
  include Featureable
  include Translatable

  default_scope { order(slug: :asc) }
end
