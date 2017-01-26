class Tag < ApplicationRecord
  include Slug

  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings
  has_many :articles, through: :taggings, source: :taggable, source_type: Tagging::ARTICLE
  has_many :pages, through: :taggings, source: :taggable, source_type: Tagging::PAGE

  before_validation :strip_whitespace, on: [:create, :update]

  validates :name, uniqueness: true

  def strip_whitespace
    self.name = name.strip
  end
end
