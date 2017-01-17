class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :articles, through: :categorizations

  validates :name, presence: true, uniqueness: true

  before_validation :generate_slug, on: [:create, :update]
  before_validation :strip_whitespace, on: [:create, :update]

  def generate_slug
    self.slug = name.to_slug
  end

  def strip_whitespace
    self.name = name.strip
  end
end
