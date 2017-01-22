class Tag < ApplicationRecord
  include Slug

  has_many :taggings, dependent: :destroy
  has_many :articles, through: :taggings

  before_validation :strip_whitespace, on: [:create, :update]

  def strip_whitespace
    self.name = name.strip
  end
end
