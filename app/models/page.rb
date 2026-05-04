class Page < ApplicationRecord
  include Post

  self.ignored_columns += [:tweet]

  default_scope { order(published_at: :desc) }

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings

  def path
    published? ? "/#{slug}" : "/drafts/pages/#{draft_code}"
  end
end
