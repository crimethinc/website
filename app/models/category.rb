class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :articles, through: :categorizations

  before_validation :generate_slug, on: [:create, :update]

  def generate_slug
    self.slug = name.to_slug
  end
end
