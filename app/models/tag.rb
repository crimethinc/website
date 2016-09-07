class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :articles, through: :taggings

  before_validation :generate_slug, on: [:create, :update]

  def generate_slug
    self.slug = name.to_slug
  end
end
