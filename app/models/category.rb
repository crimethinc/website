class Category < ApplicationRecord
  include Slug

  has_many :categorizations, dependent: :destroy
  has_many :articles, through: :categorizations

  validates :name, presence: true, uniqueness: true

  before_validation :strip_whitespace, on: [:create, :update]

  def strip_whitespace
    self.name = name.strip
  end
end
